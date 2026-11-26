#!/usr/bin/env bash
# Build the panel locally, upload sources, and build and start the remote image.
# Usage: ./deploy.sh user@vps [target-directory]
# Defaults to /opt/wonkru-mdm-source.
# Requires an existing <target>/deploy/vps/.env on the server.
set -euo pipefail

POSITIONAL=()
for arg in "$@"; do
  case "$arg" in
    --help|-h)
      echo "Kullanim: $0 kullanici@vps [hedef-dizin]"
      exit 0 ;;
    -*) echo "Bilinmeyen arguman: $arg" >&2; exit 1 ;;
    *) POSITIONAL+=("$arg") ;;
  esac
done
if (( ${#POSITIONAL[@]} < 1 || ${#POSITIONAL[@]} > 2 )); then
  echo "Kullanim: $0 kullanici@vps [hedef-dizin]" >&2
  exit 1
fi
TARGET="${POSITIONAL[0]}"
REMOTE_DIR="${POSITIONAL[1]:-/opt/wonkru-mdm-source}"
REMOTE_DIR="${REMOTE_DIR%/}"
if [[ ! "$TARGET" =~ ^[a-zA-Z0-9_@.:-]+$ || "$TARGET" == -* ||
      ! "$REMOTE_DIR" =~ ^/[a-zA-Z0-9_./-]+$ ||
      "$REMOTE_DIR/" == *'/../'* || "$REMOTE_DIR/" == *'/./'* || "$REMOTE_DIR" == *'//'* ]]; then
  echo "Gecersiz SSH hedefi veya hedef dizin (mutlak, bosluksuz yol gerekli)." >&2
  exit 1
fi

# Resolve the target on the VPS before rsync can delete anything there.
ssh "$TARGET" "bash -s -- '$REMOTE_DIR'" <<'PREFLIGHT'
set -euo pipefail
if ! cd -- "$1" || [[ "$(pwd -P)" != "$1" ]]; then
  echo "Use the real (non-symlink) path of an existing source deployment directory." >&2
  exit 1
fi
target="$PWD"
while [[ "$target" != / ]]; do
  if [[ -e "$target/.wonkru-pending" || -e "$target/.wonkru-lock" ]] ||
     grep -q '^x-wonkru-mode:' "$target/docker-compose.override.yaml" 2>/dev/null; then
    echo "Destination overlaps a ready-image installation: $target" >&2
    exit 1
  fi
  target="${target%/*}"
  target="${target:-/}"
done
if [[ ! -s deploy/vps/.env ]]; then
  echo "Prepare $PWD/deploy/vps/.env before deploying from source." >&2
  exit 1
fi
ready_install="$(find . \( -name .wonkru-pending -o -name .wonkru-lock -o \
  \( -name docker-compose.override.yaml -type f -exec grep -q '^x-wonkru-mode:' {} \; \) \) -print -quit)"
if [[ -n "$ready_install" ]]; then
  echo "Destination contains a ready-image installation: $ready_install" >&2
  exit 1
fi
PREFLIGHT

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
umask 077
bash "$ROOT/deploy/fetch-agent-apk.sh"

echo "==> Panel derleniyor (wonkru_mdm_server/web/app)"
(cd "$ROOT/wonkru_mdm_server" && serverpod run flutter_build)

echo "==> Kaynak $TARGET:$REMOTE_DIR dizinine kopyalaniyor"
rsync -az --delete \
  --exclude '.git' --exclude '.dart_tool' --exclude 'build' \
  --exclude 'wonkru_mdm_mobil' --exclude 'wonkru_mdm_flutter' \
  --exclude 'wonkru_mdm_server/.serverpod' --exclude 'wonkru_mdm_server/storage' \
  --exclude 'wonkru_mdm_server/config/passwords.yaml' \
  --exclude 'deploy/vps/.env' \
  --exclude 'deploy/vps/certs' \
  --exclude 'deploy/vps/backups' --exclude 'deploy/vps/.demo-import*' \
  --exclude '.DS_Store' \
  "$ROOT/" "$TARGET:$REMOTE_DIR/"

echo "==> VPS'te imaj derlenip baslatiliyor"
ssh "$TARGET" "cd '$REMOTE_DIR/deploy/vps' && docker compose -f docker-compose.yaml -f docker-compose.build.yaml up -d --build && docker compose ps"
