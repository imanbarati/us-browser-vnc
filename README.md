# US-browser VNC on free tiers

A self-hosted remote browser: Chromium inside a Linux VM, exposed through noVNC
and optionally Caddy for HTTPS. The browser runs in a US region, so the sites it
visits see a US IP without installing a VPN client on your own machine.

This project lives in the Craft Anything workspace folder, but it is written as
plain infrastructure code. The Craft Anything builder is for website recreation
and is not needed to deploy a VM.

## What I will not do

- I will not create cloud accounts, automate sign-ups, or keep logins/passwords
  for you. Account creation must be done by you. If a page needs a login, use
  the browser vault so the secret never enters this repository or the chat.
- I will not help create multiple accounts to claim repeated free credits, or
  to evade a ban imposed by a specific website or provider.
- I cannot promise "no ban by any party." No service can.

## Reality check

| Claim | Truth |
|---|---|
| US IP via free cloud | Yes — a VM in `us-east-1`, `us-ashburn-1`, etc. |
| No VPN client needed | Yes — you use a browser tab (noVNC) instead of a VPN. |
| Invisible as a datacenter IP | No. AWS/Oracle/GitHub IPs are widely known cloud ranges. |
| No CAPTCHAs or site blocks | No. Many consumer sites challenge or ban cloud IPs. |
| Cloudflare free can host VNC | No. Workers/Pages have no persistent desktop or general outbound browser. |
| GitHub Codespaces is a permanent US browser | No. It is temporary and not for general browsing/proxying. |

Your own account, used normally, is fine. Read each provider's terms.

## Options

| Option | Free allowance | US region | Persistent | Notes |
|---|---|---|---|---|
| Oracle Cloud Always Free ARM | 1 OCPU / 6 GB, ongoing | `us-ashburn-1` etc. | Yes | Best free VM; capacity can be unavailable |
| AWS EC2 free tier | t2.micro, 12 months | `us-east-1` etc. | Yes while eligible | 1 GB RAM; set billing alarms |
| GitHub Codespaces | monthly free hours | GitHub US infra | No | Dev/test only; port-forwarded 6080 |
| Google Cloud Shell | limited free | US | No | Not a general browser |
| Cloudflare Workers/Pages | generous free | Edge | N/A | No VNC/outbound browser |
| Residential proxy services | paid | US residential | Yes | Not free; often ToS-sensitive |

## Deploy

1. Create the account yourself and configure the provider CLI.
2. Pick one of `providers/aws`, `providers/oracle`, or
   `providers/codespaces` and follow its README.
3. For a VM, copy this repo to the VM and run:

```bash
bash scripts/bootstrap.sh
```

4. Set `DOMAIN` in `.env` to a domain you control for HTTPS via Caddy. For a
   quick test, leave it as `localhost` and open `http://VM-IP:6080/vnc.html`.
5. Connect with the VNC password from `.env`.

The noVNC endpoint is bound to `127.0.0.1` on the VM; Caddy publishes 80/443.
For extra protection, put the domain behind Cloudflare Access (free tier) or
restrict port 22 to your IP (the AWS script does this).

## Files

```
docker/Dockerfile          Chromium + Xvfb + x11vnc + websockify
docker/entrypoint.sh       starts the desktop and noVNC
docker-compose.yml         browser + Caddy
Caddyfile                  HTTPS reverse proxy
scripts/bootstrap.sh       one-command VM setup
providers/aws/             t2.micro US-region provisioning
providers/oracle/          Always Free ARM provisioning
providers/codespaces/      devcontainer + start script
comparison.md              detailed trade-offs
```

## Verification performed

All shell scripts pass `bash -n`; the JSON devcontainer parses; the Compose and
Caddy files are syntax-checked where tooling is available. No cloud resources
were created during development, and no credentials are stored in this repo.
