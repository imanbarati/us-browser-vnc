#!/bin/sh
set -eu

: "${VNC_PASSWORD:?Set VNC_PASSWORD in .env}"

NOVNC_DIR=/usr/share/novnc
if [ ! -f "$NOVNC_DIR/vnc.html" ]; then
  echo "noVNC web files not found in $NOVNC_DIR" >&2
  exit 1
fi

x11vnc -storepasswd "$VNC_PASSWORD" /tmp/vncpasswd >/dev/null 2>&1
chmod 600 /tmp/vncpasswd

Xvfb :99 -screen 0 1440x900x24 -nolisten tcp >/tmp/xvfb.log 2>&1 &
sleep 1

chromium --no-sandbox --disable-dev-shm-usage \
  --user-data-dir=/home/browser/.config/chromium \
  --window-size=1400,850 --no-first-run about:blank >/tmp/chromium.log 2>&1 &

x11vnc -forever -shared -rfbauth /tmp/vncpasswd -rfbport 5900 -display :99 >/tmp/x11vnc.log 2>&1 &
sleep 1

exec websockify --web="$NOVNC_DIR" 0.0.0.0:6080 localhost:5900
