#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v docker >/dev/null 2>&1; then
  echo "Installing Docker..."
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -y
    sudo apt-get install -y docker.io docker-compose-plugin git curl openssl
  else
    echo "Install Docker for this OS, then rerun this script." >&2
    exit 1
  fi
fi
sudo usermod -aG docker "$USER" 2>/dev/null || true

if [ ! -f .env ]; then
  cp .env.example .env
  if command -v openssl >/dev/null 2>&1; then
    generated="$(openssl rand -base64 18 | tr -d '/+=')"
    sed -i "s/^VNC_PASSWORD=.*/VNC_PASSWORD=${generated}/" .env
    echo "Generated VNC password (also stored in .env): ${generated}"
  fi
  read -r -p "Domain for HTTPS (localhost for VM IP testing): " domain
  [ -n "$domain" ] && sed -i "s/^DOMAIN=.*/DOMAIN=${domain}/" .env
fi

echo "Starting noVNC browser + Caddy..."
sudo -E docker compose up -d --build
echo "Ready. noVNC: https://$(grep '^DOMAIN=' .env | cut -d= -f2)/vnc.html or http://VM-IP:6080/vnc.html"
