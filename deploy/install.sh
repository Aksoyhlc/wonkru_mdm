#!/usr/bin/env bash
set -euo pipefail
umask 077

REPO=Aksoyhlc/wonkru_mdm
IMAGE=wonkrumdm/wonkrumdm
LEGACY_IMAGE=aksoyhlc/wonkru-mdm
PROJECT=wonkru-mdm-image
SCRIPT_PATH="${BASH_SOURCE[0]:-}"
TAG_PATTERN='^v(0|[1-9][0-9]{0,8})\.(0|[1-9][0-9]{0,8})\.(0|[1-9][0-9]{0,8})$'
MANAGED=(docker-compose.yaml docker-compose.override.yaml Caddyfile .env.example init-env.sh install.sh .env)

usage() {
  cat <<'HELP'
Usage: install.sh [--non-interactive] [--dir DIRECTORY] [--host HOST] [--api-port PORT] [--panel-port PORT]
       install.sh [--non-interactive] [--dir DIRECTORY] --api-host DOMAIN --panel-host DOMAIN --email EMAIL
       install.sh update [--dir DIRECTORY]

Ubuntu/Debian: run as root. macOS: start Docker Desktop and run as your user.
Default directory: /opt/wonkru-mdm on Linux, $HOME/wonkru-mdm on macOS.
HTTP defaults to 8080 for the API and 8082 for the panel. HTTPS uses 80 and 443.
On first install, a terminal can supply missing options. Use --non-interactive to skip prompts.
HELP
}

die() { printf 'Wonkru MDM: %s\n' "$*" >&2; exit 1; }

version_key() {
  local major minor patch
  IFS=. read -r major minor patch <<< "${1#v}"
  printf '%09d%09d%09d' "$major" "$minor" "$patch"
}

valid_hostname() {
  local label labels
  [[ "$1" =~ ^[a-zA-Z0-9.-]{1,253}$ && "$1" != .* && "$1" != *. && "$1" != *..* ]] || return 1
  IFS=. read -r -a labels <<< "$1"
  for label in "${labels[@]}"; do
    [[ "$label" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$ ]] || return 1
  done
}

valid_port() {
  [[ "$1" =~ ^[1-9][0-9]{0,4}$ && "$1" != "${2:-}" ]] && (( $1 <= 65535 ))
}

lowercase() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }

valid_domain() {
  [[ "$1" == *.* && "$1" =~ [a-zA-Z] ]] && valid_hostname "$1" || return 1
  [[ -z "${2:-}" || "$(lowercase "$1")" != "$(lowercase "$2")" ]]
}

valid_email() { [[ "$1" =~ ^[a-zA-Z0-9_.%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; }
valid_mode_choice() { [[ "$1" == 1 || "$1" == 2 ]]; }

default_http_host() {
  if [[ "$os" == Darwin ]]; then
    printf '%s\n' localhost
  elif command -v ip >/dev/null; then
    ip -4 route get 1.1.1.1 2>/dev/null |
      awk '{ for (i = 1; i < NF; i++) if ($i == "src") { print $(i+1); exit } }'
  else
    hostname -I 2>/dev/null |
      awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^[0-9.]+$/) { print $i; exit } }'
  fi
}

ask_missing() {
  local field="$1" label="$2" default_value="$3" validate="$4" answer
  shift 4
  [[ -z "${!field}" ]] || return 0
  if [[ "$has_terminal" == false ]]; then
    printf -v "$field" '%s' "$default_value"
    return
  fi

  if ! "$validate" "$default_value" "$@"; then default_value=''; fi
  while :; do
    if [[ -n "$default_value" ]]; then
      printf '%s [%s]: ' "$label" "$default_value" >&3
    else
      printf '%s: ' "$label" >&3
    fi
    IFS= read -r answer <&3 || die 'Setup canceled before installation.'
    answer="${answer:-$default_value}"
    if "$validate" "$answer" "$@"; then
      printf -v "$field" '%s' "$answer"
      return
    fi
    printf 'Invalid value. Try again.\n' >&3
  done
}

select_install_settings() {
  local has_terminal=false choice='' detected_host=''
  mode=http
  if [[ -n "$api_host$panel_host$email" ]]; then
    [[ -z "$host$api_port$panel_port" ]] ||
      die '--host, --api-port, and --panel-port are available for HTTP only.'
    mode=https
  fi

  [[ -z "$host" ]] || valid_hostname "$host" || die 'Invalid --host. Use an IPv4 address or hostname.'
  [[ -z "$api_port" ]] || valid_port "$api_port" || die '--api-port must be between 1 and 65535.'
  [[ -z "$panel_port" ]] || valid_port "$panel_port" || die '--panel-port must be between 1 and 65535.'
  [[ -z "$api_host" ]] || valid_domain "$api_host" || die 'Invalid --api-host. Use a domain name.'
  [[ -z "$panel_host" ]] || valid_domain "$panel_host" || die 'Invalid --panel-host. Use a domain name.'
  [[ -z "$email" ]] || valid_email "$email" || die 'Invalid --email. Use a valid email address.'

  if [[ "$non_interactive" == false ]] && { exec 3<> /dev/tty; } 2>/dev/null; then
    has_terminal=true
  fi
  if [[ "$has_terminal" == true && "$address_options" == false ]]; then
    printf '1) HTTP on a trusted network\n2) HTTPS with domain names\n' >&3
    ask_missing choice 'Choose a setup' 1 valid_mode_choice
    if [[ "$choice" == 2 ]]; then mode=https; fi
  fi

  if [[ "$mode" == https ]]; then
    ask_missing api_host 'API domain' '' valid_domain "$panel_host"
    ask_missing panel_host 'Panel domain (different from API domain)' '' valid_domain "$api_host"
    ask_missing email 'Certificate contact email' '' valid_email
    [[ -n "$api_host" ]] || die 'HTTPS requires --api-host.'
    [[ -n "$panel_host" ]] || die 'HTTPS requires --panel-host.'
    [[ -n "$email" ]] || die 'HTTPS requires --email.'
    api_host="$(lowercase "$api_host")"
    panel_host="$(lowercase "$panel_host")"
    [[ "$api_host" != "$panel_host" ]] || die 'The API and panel need different domains.'
  else
    if [[ -z "$host" ]]; then detected_host="$(default_http_host)" || :; fi
    ask_missing host 'HTTP address' "$detected_host" valid_hostname
    [[ -n "$host" ]] || die 'Could not determine an IPv4 address. Set --host.'
    ask_missing api_port 'API port (1 to 65535)' 8080 valid_port "$panel_port"
    ask_missing panel_port 'Panel port (different from API port)' 8082 valid_port "$api_port"
    [[ "$api_port" != "$panel_port" ]] || die 'The API and panel need different ports.'
  fi

  if [[ "$has_terminal" == true ]]; then exec 3>&-; fi
}

install_docker() {
  local id version_codename source_dir=/etc/apt/sources.list.d
  # shellcheck disable=SC1091
  . /etc/os-release
  id="$ID"
  version_codename="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"
  [[ "$id" == ubuntu || "$id" == debian ]] || die 'Docker bootstrap supports Ubuntu and Debian.'
  [[ "$version_codename" =~ ^[a-z][a-z0-9-]*$ ]] || die 'Could not determine the distribution codename.'

  if ! grep -q 'download\.docker\.com/linux/' /etc/apt/sources.list 2>/dev/null &&
     ! grep -rq 'download\.docker\.com/linux/' "$source_dir" 2>/dev/null; then
    install -d -m 0755 /etc/apt/keyrings "$source_dir"
    curl -fsSL "https://download.docker.com/linux/$id/gpg" -o "$lock/docker.asc"
    install -m 0644 "$lock/docker.asc" /etc/apt/keyrings/docker.asc
    cat > "$lock/docker.sources" <<EOF
Types: deb
URIs: https://download.docker.com/linux/$id
Suites: $version_codename
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
    install -m 0644 "$lock/docker.sources" "$source_dir/docker.sources"
  fi

  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  systemctl enable --now docker
}

ensure_dependencies() {
  local v
  if [[ "$os" == Linux ]]; then
    local packages=()
    command -v jq >/dev/null || packages+=(jq)
    command -v openssl >/dev/null || packages+=(openssl)
    command -v ip >/dev/null || packages+=(iproute2)
    if (( ${#packages[@]} )); then
      apt-get update
      DEBIAN_FRONTEND=noninteractive apt-get install -y "${packages[@]}"
    fi
    command -v docker >/dev/null || install_docker
  else
    command -v docker >/dev/null || die 'Install and start Docker Desktop.'
  fi

  docker info >/dev/null 2>&1 || die 'Docker is not running or the current user cannot reach it.'
  v="$(docker compose version --short 2>/dev/null)" || die 'Docker Compose 2.24.4 or newer is required.'
  [[ "$v" =~ ^v?([0-9]+)\.([0-9]+)\.([0-9]+) ]] ||
    die "Could not read Docker Compose version: $v."
  local major="${BASH_REMATCH[1]}" minor="${BASH_REMATCH[2]}" patch="${BASH_REMATCH[3]}"
  (( major > 2 || (major == 2 && (minor > 24 || (minor == 24 && patch >= 4))) )) ||
    die "Docker Compose 2.24.4 or newer is required (found $v)."
}

require_unused_project() {
  local containers volumes
  containers="$(docker ps -aq --filter "label=com.docker.compose.project=$PROJECT")"
  volumes="$(docker volume ls -q --filter "label=com.docker.compose.project=$PROJECT")"
  [[ -z "$containers$volumes" ]] ||
    die "Docker already has resources for $PROJECT. Use the original installation directory and .env."
}

json_string() {
  if [[ "$os" == Darwin ]]; then
    /usr/bin/perl -MJSON::PP -e '
      local $/;
      my $value = decode_json(<STDIN>);
      for my $key (split /\./, $ARGV[0]) { $value = $value->{$key}; }
      exit 1 if !defined($value) || ref($value) || $value eq "";
      print "$value\n";
    ' "$1"
  else
    jq -er ".$1 | strings | select(length > 0)"
  fi
}

compose() (
  local files="$1"
  shift
  if [[ -f "$root/docker-compose.local.yaml" ]]; then
    set -- -f "$root/docker-compose.local.yaml" "$@"
  fi
  unset WONKRU_IMAGE COMPOSE_REMOVE_ORPHANS COMPOSE_IGNORE_ORPHANS COMPOSE_PROFILES
  docker compose --project-directory "$root" --project-name "$PROJECT" \
    --env-file "$files/.env" -f "$files/docker-compose.yaml" \
    -f "$files/docker-compose.override.yaml" "$@"
)

latest_release() {
  local tag
  tag="$(curl -fsSL --retry 3 --connect-timeout 15 \
    "https://api.github.com/repos/$REPO/releases/latest" | json_string tag_name)" ||
    die 'Could not read the latest GitHub Release. Check GitHub access and published releases.'
  [[ "$tag" =~ $TAG_PATTERN ]] || die "Unexpected release tag: $tag"
  printf '%s\n' "$tag"
}

download() {
  curl -fsSL --retry 3 --connect-timeout 15 \
    "https://raw.githubusercontent.com/$REPO/$1/deploy/$2" -o "$3"
}

prepare_release() {
  local tag="$1" mode="$2" file
  stage="$(mktemp -d "$root/.wonkru-stage.XXXXXX")"
  for file in docker-compose.yaml Caddyfile .env.example init-env.sh; do
    download "$tag" "vps/$file" "$stage/$file"
  done
  download "$tag" "vps/docker-compose.$mode.yaml" "$stage/docker-compose.override.yaml"
  download "$tag" install.sh "$stage/install.sh"
  # Earlier tags bundled a launcher that still uses the old registry path.
  if grep -Fxq "IMAGE=$LEGACY_IMAGE" "$stage/install.sh"; then
    download main install.sh "$stage/install.sh"
    grep -Fxq "IMAGE=$IMAGE" "$stage/install.sh" ||
      die 'The current installer is not available yet. Retry in a few minutes.'
  fi
  chmod 700 "$stage/install.sh"
}

configure_first_install() {
  local scheme=http bind=127.0.0.1 secure=false api_site='http://:8080' web_site='http://:8082'
  local api_origin panel_origin
  if [[ "$mode" == https ]]; then
    scheme=https
    secure=true
    api_port=443
    panel_port=443
    api_site="https://$api_host"
    web_site="https://$panel_host"
    api_origin="$api_site"
    panel_origin="$web_site"
  else
    if [[ "$os" == Linux ]]; then bind=0.0.0.0; fi
    api_host="$(lowercase "$host")"
    panel_host="$api_host"
    api_origin="http://$api_host"
    panel_origin="http://$panel_host"
    if [[ "$api_port" != 80 ]]; then api_origin+=":$api_port"; fi
    if [[ "$panel_port" != 80 ]]; then panel_origin+=":$panel_port"; fi
  fi

  bash "$stage/init-env.sh"
  awk '
    !/^(WONKRU_IMAGE|HTTP_BIND_IP|API_PUBLIC_SCHEME|API_PUBLIC_HOST|API_PUBLIC_PORT|WEB_PUBLIC_SCHEME|WEB_PUBLIC_HOST|WEB_PUBLIC_PORT|PANEL_ORIGIN|APP_URL|API_SITE|WEB_SITE|ACME_EMAIL|API_PORT|WEB_PORT|AUTH_COOKIE_SECURE)=/
  ' "$stage/.env" > "$stage/.env.new"
  cat >> "$stage/.env.new" <<EOF
WONKRU_IMAGE=$IMAGE:$tag
HTTP_BIND_IP=$bind
API_PUBLIC_SCHEME=$scheme
API_PUBLIC_HOST=$api_host
API_PUBLIC_PORT=$api_port
WEB_PUBLIC_SCHEME=$scheme
WEB_PUBLIC_HOST=$panel_host
WEB_PUBLIC_PORT=$panel_port
PANEL_ORIGIN=$panel_origin
APP_URL=$api_origin
API_SITE=$api_site
WEB_SITE=$web_site
ACME_EMAIL=$email
API_PORT=$api_port
WEB_PORT=$panel_port
AUTH_COOKIE_SECURE=$secure
EOF
  mv "$stage/.env.new" "$stage/.env"
}

install_version() {
  local config="$1" allow_legacy="${2:-false}" image tag
  image="$(compose "$config" config --format json | json_string services.server.image)" || return 1
  if [[ "$image" != "$IMAGE:"* &&
        ( "$allow_legacy" != true || "$image" != "$LEGACY_IMAGE:"* ) ]]; then
    die "WONKRU_IMAGE must point to $IMAGE:vX.Y.Z."
  fi
  tag="${image#*:}"
  [[ "$tag" =~ $TAG_PATTERN ]] || die 'WONKRU_IMAGE must use a vX.Y.Z tag.'
  printf '%s\n' "$tag"
}

start_installation() {
  local panel command=bash
  panel="$(compose "$root" config --format json | json_string services.server.environment.SERVERPOD_ALLOWED_ORIGINS)"
  if ! {
    if [[ -f "$pending/recreate-caddy" ]]; then
      compose "$root" up -d --wait postgres server &&
        compose "$root" up -d --wait --no-deps --force-recreate caddy
    else
      compose "$root" up -d --wait
    fi
  }; then
    printf 'Deployment did not start. Check logs: cd %q && docker compose logs --tail 80 server caddy\n' "$root" >&2
    if [[ -f "$pending/backup-path" ]]; then
      printf 'Previous configuration: %s\n' "$(cat "$pending/backup-path")" >&2
    fi
    if [[ -d "$pending" ]]; then
      if [[ "$os" == Linux ]]; then command='sudo bash'; fi
      printf 'After resolving the issue, run %s %q update again.\n' "$command" "$root/install.sh" >&2
    fi
    exit 1
  fi
  printf 'Wonkru MDM panel: %s\n' "$panel"
}

apply_pending() {
  local file
  if [[ ! -f "$pending/applied" ]]; then
    mkdir -p "$root/certs"
    for file in "${MANAGED[@]}"; do
      if ! cmp -s "$pending/$file" "$root/$file"; then
        cp -p "$pending/$file" "$lock/next-file"
        mv -f "$lock/next-file" "$root/$file"
      fi
    done
    touch "$pending/applied"
  fi
  chmod 600 "$root/.env"
  start_installation
  rm -r -- "$pending"
}

queue_release() {
  local previous="${1:-}" backup file
  compose "$stage" config --quiet
  [[ "$(install_version "$stage")" == "$tag" ]] || die 'Staged Compose image tag does not match the release.'
  if [[ -n "$previous" ]]; then
    compose "$stage" pull --policy always server
    cmp -s "$stage/previous-env" "$root/.env" ||
      die '.env changed while preparing the update. Run update again.'
    mkdir -p "$root/.wonkru-backups"
    backup="$(mktemp -d "$root/.wonkru-backups/$previous.XXXXXX")"
    for file in "${MANAGED[@]}"; do
      if [[ -f "$root/$file" ]]; then cp -p "$root/$file" "$backup/$file"; fi
    done
    chmod 600 "$backup/.env"
    printf '%s\n' "$backup" > "$stage/backup-path"
    if ! cmp -s "$stage/Caddyfile" "$root/Caddyfile"; then
      touch "$stage/recreate-caddy"
    fi
  else
    compose "$stage" pull
  fi

  mv "$stage" "$pending"
  stage=''
  apply_pending
}

main() {
  local starter_password script_dir
  action=install
  if [[ "${1:-}" == update ]]; then
    action=update
    shift
  fi
  if [[ "${1:-}" == --help || "${1:-}" == -h ]]; then usage; exit 0; fi
  root='' host='' api_host='' panel_host='' email='' api_port='' panel_port=''
  address_options=false non_interactive=false
  while (( $# )); do
    if [[ "$1" == --non-interactive ]]; then
      non_interactive=true
      shift
      continue
    fi
    [[ -n "${2:-}" && "$2" != --* ]] || die "Missing value for $1."
    case "$1" in
      --dir) root="$2" ;;
      --host) host="$2"; address_options=true ;;
      --api-host) api_host="$2"; address_options=true ;;
      --panel-host) panel_host="$2"; address_options=true ;;
      --email) email="$2"; address_options=true ;;
      --api-port) api_port="$2"; address_options=true ;;
      --panel-port) panel_port="$2"; address_options=true ;;
      *) die "Unknown option: $1. See --help." ;;
    esac
    shift 2
  done

  if [[ "$action" == update && "$address_options" == true ]]; then
    die 'Change addresses and ports in .env before running Docker Compose.'
  fi

  os="$(uname -s)"
  case "$os" in
    Linux)
      (( EUID == 0 )) || die 'Run this installer as root on Linux.'
      [[ -r /etc/os-release ]] || die 'This installer supports Ubuntu and Debian.'
      (
        # shellcheck disable=SC1091
        . /etc/os-release
        [[ "$ID" == ubuntu || "$ID" == debian ]]
      ) || die 'This installer supports Ubuntu and Debian.'
      default_root=/opt/wonkru-mdm
      ;;
    Darwin)
      (( EUID != 0 )) || die 'Run this installer without sudo on macOS.'
      default_root="$HOME/wonkru-mdm"
      ;;
    *) die "Unsupported operating system: $os" ;;
  esac
  case "$(uname -m)" in
    x86_64|aarch64|arm64) ;;
    *) die 'Wonkru MDM images are published for amd64 and arm64.' ;;
  esac

  if [[ "$action" == update && -z "$root" && -f "$SCRIPT_PATH" ]]; then
    script_dir="$(dirname -- "$SCRIPT_PATH")"
    if [[ -d "$script_dir/.wonkru-pending" ||
          ( -f "$script_dir/.env" &&
            -f "$script_dir/docker-compose.yaml" &&
            -f "$script_dir/docker-compose.override.yaml" ) ]]; then
      root="$script_dir"
    fi
  fi
  root="${root:-$default_root}"
  [[ "$root" == /* ]] || root="$PWD/$root"
  mkdir -p -- "$root"
  root="$(cd -- "$root" && pwd -P)"
  [[ "$root" != / && ! -e "$root/deploy/vps" && ! -e "$root/.git" ]] ||
    die "Choose a directory for the ready-image installation: $root"
  for file in "${MANAGED[@]}"; do
    [[ ! -L "$root/$file" ]] || die "Refusing to replace a symbolic link: $root/$file"
    [[ ! -e "$root/$file" || -f "$root/$file" ]] || die "Expected a regular file: $root/$file"
  done
  for directory in .wonkru-backups .wonkru-pending; do
    [[ ! -L "$root/$directory" && ( ! -e "$root/$directory" || -d "$root/$directory" ) ]] ||
      die "Expected a regular directory: $root/$directory"
  done

  lock="$root/.wonkru-lock"
  pending="$root/.wonkru-pending"
  mkdir -- "$lock" 2>/dev/null || die "Installation is locked: $lock"
  stage=''
  cleanup() {
    if [[ -n "$stage" ]]; then rm -rf -- "$stage"; fi
    rm -rf -- "$lock"
  }
  trap cleanup EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM

  if [[ -d "$pending" ]]; then
    ensure_dependencies
    apply_pending
    exit 0
  fi

  if [[ -f "$root/.env" && -f "$root/docker-compose.override.yaml" && -f "$root/docker-compose.yaml" ]]; then
    mode="$(awk '$1 == "x-wonkru-mode:" { print $2; exit }' "$root/docker-compose.override.yaml")"
    [[ "$mode" == http || "$mode" == https ]] || die "Not a ready-image installation: $root"
    [[ "$address_options" == false ]] || die 'This installation already has settings. Edit .env to change them.'
    ensure_dependencies
    installed="$(install_version "$root" true)"
    if [[ "$action" == install ]]; then
      start_installation
      exit 0
    fi
    tag="$(latest_release)"
    LC_ALL=C
    [[ "$(version_key "$tag")" < "$(version_key "$installed")" ]] &&
      die "Published release $tag is older than the installed $installed."
    prepare_release "$tag" "$mode"
    cp -p "$root/.env" "$stage/previous-env"
    # Preserve the existing environment while updating the release image pin.
    awk -v image="$IMAGE:$tag" '
      /^[[:space:]]*(export[[:space:]]+)?WONKRU_IMAGE[[:space:]]*=/ {
        if (!written++) print "WONKRU_IMAGE=" image
        next
      }
      { print }
      END { if (!written) print "WONKRU_IMAGE=" image }
    ' "$stage/previous-env" > "$stage/.env"
    if grep -q '^STARTER_ADMIN_PASSWORD=$' "$stage/.env.example" &&
       ! grep -Eq '^[[:space:]]*(export[[:space:]]+)?STARTER_ADMIN_PASSWORD[[:space:]]*=' "$stage/.env"; then
      starter_password="$(openssl rand -hex 10)"
      printf 'STARTER_ADMIN_PASSWORD=%s\n' "$starter_password" >> "$stage/.env"
    fi
    queue_release "$installed"
  else
    [[ "$action" == install ]] || die "No ready-image installation found in $root."
    for file in "${MANAGED[@]}"; do
      [[ ! -e "$root/$file" ]] || die "Choose a fresh directory. Existing file: $root/$file"
    done
    select_install_settings
    ensure_dependencies
    require_unused_project
    tag="$(latest_release)"
    prepare_release "$tag" "$mode"
    configure_first_install
    queue_release
  fi
}

main "$@"
