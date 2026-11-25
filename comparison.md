# Cloud free-tier comparison for a US-IP remote browser

## Cloudflare free

Cloudflare Workers and Pages cannot run a persistent desktop or a general
outbound browser. Cloudflare Access (free tier) *can* protect a noVNC domain you
host elsewhere, which is the only role Cloudflare plays here.

## Oracle Cloud Always Free

- Shape: `VM.Standard.A1.Flex`, 1 OCPU / 6 GB, ARM64.
- Regions include US Ashburn/Phoenix. Persistent while the account is active.
- Free ARM capacity is frequently exhausted; retry or change domain.
- Ubuntu 22.04 aarch64 image works with the Compose stack here.
- Datacenter IP reputation: moderate-to-low for consumer sites.

## AWS Free Tier

- `t2.micro`, 12 months from account creation, US East etc.
- 1 GB RAM is tight but workable for one Chromium window.
- Set billing alarms; anything outside the free tier costs money.
- Datacenter IP reputation: low; AWS ranges are heavily filtered.

## GitHub Codespaces

- Fast to start, no VM management, port 6080 forwarded automatically.
- Ephemeral: state disappears when the codespace stops.
- GitHub's acceptable use policy does not permit running a general
  browsing proxy or evading service restrictions. Use for development only.

## Other free options

- Google Cloud Shell: a browser terminal, not a persistent desktop.
- Replit/Render/Koyeb free web containers: no full desktop/VNC generally.
- Free-trial VPS offers: time-limited and usually require card details.
- Residential proxy networks: not free, and often violate website terms.

## Ban reality

A US IP is not a guarantee of acceptance. Web services classify IPs by ASN,
behaviour and reputation. Datacenter IPs are routinely challenged even in the
"correct" country. The only way to reduce challenges is to follow each site's
rules from your own legitimate session — not to rotate infrastructure.
