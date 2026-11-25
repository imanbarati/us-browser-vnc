FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:99

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      xvfb x11vnc chromium novnc websockify ca-certificates fonts-liberation \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash browser \
 && mkdir -p /home/browser/.config /home/browser/Downloads \
 && chown -R browser:browser /home/browser

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh

USER browser
EXPOSE 6080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
