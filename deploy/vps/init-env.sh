#!/usr/bin/env bash
# Generate .env from .env.example and fill the supported secret values.
# Usage: ./init-env.sh [HOST] [ACME_EMAIL]
# HOST replaces CHANGE_ME in public addresses; ACME_EMAIL sets the ACME account email.

set -euo pipefail
cd "$(dirname "$0")"

if [[ -f .env ]]; then
  echo ".env zaten var; sirlari ezmemek icin dokunulmadi." >&2
  exit 1
fi

HOST="${1:-}"
ACME_EMAIL="${2:-}"

secret() { openssl rand -base64 48 | tr -d '\n/+=' | cut -c1-48; }

# Generate only these secrets; preserve all other template values.
is_secret() {
  case "$1" in
    DB_PASSWORD | SERVICE_SECRET | EMAIL_SECRET_HASH_PEPPER | \
      JWT_HMAC_SHA512_PRIVATE_KEY | JWT_REFRESH_TOKEN_HASH_PEPPER | \
      STORAGE_SIGNING_KEY | PASSWORD_HASH_PEPPER)
      return 0
      ;;
    *) return 1 ;;
  esac
}

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

while IFS= read -r line; do
  key="${line%%=*}"
  if [[ "$line" == 'STARTER_ADMIN_PASSWORD=' ]]; then
    starter_password="$(openssl rand -hex 10)"
    printf 'STARTER_ADMIN_PASSWORD=%s\n' "$starter_password"
  elif is_secret "$key" && [[ "$line" == "$key=" ]]; then
    echo "$key=$(secret)"
  else
    echo "$line"
  fi
done < .env.example > "$tmp"

if [[ -n "$HOST" ]]; then
  sed -i.bak "s|CHANGE_ME|${HOST}|g" "$tmp" && rm -f "$tmp.bak"
fi
if [[ -n "$ACME_EMAIL" ]]; then
  sed -i.bak "s|^ACME_EMAIL=.*|ACME_EMAIL=${ACME_EMAIL}|" "$tmp" && rm -f "$tmp.bak"
fi

mv "$tmp" .env
chmod 600 .env
echo ".env olusturuldu. Modu ve public uclari .env icinden dogrulayin." >&2
