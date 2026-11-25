#!/usr/bin/env bash
# macOS / Linux install wizard for the noVNC browser stack.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

command -v docker >/dev/null 2>&1 || {
  echo "Docker is required. Install Docker Engine or Docker Desktop first."
  exit 1
}

if [ ! -f .env ]; then
  cp .env.example .env
  if command -v openssl >/dev/null 2>&1; then
    pass="$(openssl rand -hex 12)"
    sed -i "s/^VNC_PASSWORD=.*/VNC_PASSWORD=$pass/" .env
    echo "Generated VNC password: $pass"
  fi
  read -r -p "Domain (localhost for local testing): " domain
  [ -n "$domain" ] && sed -i "s/^DOMAIN=.*/DOMAIN=$domain/" .env
fi

echo "Starting stack..."
docker compose up -d --build
echo "Done. Open http://127.0.0.1:6080/vnc.html or https://$(grep '^DOMAIN=' .env | cut -d= -f2)/vnc.html"
