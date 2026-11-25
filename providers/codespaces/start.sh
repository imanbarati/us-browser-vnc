#!/usr/bin/env bash
set -euo pipefail

if ! command -v chromium >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y --no-install-recommends \
    chromium xvfb x11vnc novnc websockify fonts-liberation
fi

export DISPLAY=:99
VNC_PASSWORD="${VNC_PASSWORD:-$(openssl rand -base64 18 | tr -d '/+=')}"
x11vnc -storepasswd "$VNC_PASSWORD" /tmp/vncpasswd >/dev/null 2>&1

pkill -f 'Xvfb :99' 2>/dev/null || true
pkill -f 'x11vnc -forever' 2>/dev/null || true
pkill -f 'websockify --web' 2>/dev/null || true

Xvfb :99 -screen 0 1440x900x24 -nolisten tcp >/tmp/xvfb.log 2>&1 &
sleep 1
chromium --no-sandbox --disable-dev-shm-usage --window-size=1400,850 about:blank >/tmp/chromium.log 2>&1 &
x11vnc -forever -shared -rfbauth /tmp/vncpasswd -rfbport 5900 -display :99 >/tmp/x11vnc.log 2>&1 &
sleep 1
websockify --web=/usr/share/novnc 0.0.0.0:6080 localhost:5900 >/tmp/websockify.log 2>&1 &

echo "Codespaces noVNC ready on forwarded port 6080."
echo "VNC password: $VNC_PASSWORD"
