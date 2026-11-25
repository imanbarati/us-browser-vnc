# Handoff — us-browser-vnc

## Current state

Repository: https://github.com/imanbarati/us-browser-vnc
Local folder: `C:\Users\Pas18\Documents\Craft Anything\us-browser-vnc`
Branch: `main`, commit `c9043b4`, working tree clean, remote matches local.

This is a **working scaffold**, not a deployed application. No cloud resources
were created during development, no accounts were opened, and no credentials are
stored anywhere in the repo.

## What exists

- `docker/Dockerfile` + `docker/entrypoint.sh`: Debian bookworm container with
  Chromium, Xvfb, x11vnc, noVNC and websockify. It serves noVNC on port 6080 and
  expects `VNC_PASSWORD`.
- `docker-compose.yml`: browser service bound to `127.0.0.1:6080`, plus Caddy
  publishing 80/443 using `Caddyfile` and `DOMAIN`.
- `scripts/bootstrap.sh`: installs Docker, creates `.env` with a generated
  password if absent, and starts the stack.
- `providers/aws/deploy.sh`: provisions one t2.micro in `us-east-1` via AWS CLI
  (security group, key pair, SSH limited to caller IP, 80/443 open).
- `providers/oracle/deploy.sh`: provisions one Always Free ARM instance via OCI
  CLI in a US region.
- `providers/codespaces/`: devcontainer + `start.sh` for a temporary forwarded
  noVNC session.
- `rust/`: dependency-free Rust CLI (`usvnc`) with `doctor`, `init`, `up`,
  `down`, `status`, `providers`, and `guide <provider>` commands.
- `install.sh`, `install.ps1`: cross-platform install wizards.
- `account-guide.sh`, `account-guide.ps1`: open signup pages and print checklists;
  they never ask for or store credentials.
- `README.md`, `comparison.md`, provider READMEs.

## Hard boundaries — do not cross

1. Do **not** automate cloud sign-ups, sign-ins, account farms, or store
   usernames/passwords/API keys in files, chat or git. The user creates accounts
   and runs CLI auth themselves. If a browser login is needed, use the vault.
2. Do **not** promise or engineer "no ban by any party." These are datacenter
   IPs; CAPTCHAs and blocks are expected on some sites. Never assist with
   evading a specific platform ban or claiming repeated promotional credits.
3. Do **not** add a VPN/proxy service that masquerades traffic beyond the remote
   browser itself. The product is a remote desktop with a US IP, nothing more.
4. Never commit `.env`, credentials, SSH private keys, or cloud tokens.

## What is verified

- All shell scripts pass `bash -n`.
- `providers/codespaces/devcontainer.json` parses as JSON.
- Debian's noVNC package serves `vnc.html` from `/usr/share/novnc`, which the
  entrypoint now checks.
- `cargo check` passes on the Rust CLI with Rust stable 1.100.0.
- MSVC linking failed (no Visual Studio linker), but MinGW was installed and
  `cargo +stable-x86_64-pc-windows-gnu build --release` produced
  `rust/target/release/usvnc.exe`. `help`, `providers`, `doctor` and `init`
  were smoke-tested with a temporary `USVNC_ROOT`.
- Git remote and local HEAD match.

## What is NOT verified

- Docker was not available locally, so the image was never built and the stack
  was never started.
- No AWS/Oracle/Codespaces resources were launched.
- No HTTPS domain, Caddy certificate, firewall or Cloudflare Access was tested.
- No real browsing session or site compatibility test was performed.

## What remains to make this an actual app

### Milestone 1 — Core stack works end to end
Acceptance: `docker compose up -d --build` on a fresh Ubuntu VM yields a working
noVNC page at `https://DOMAIN/vnc.html`, Chromium loads, password auth works,
and restart survives `docker compose restart`.

### Milestone 2 — Idempotent, safe providers
Acceptance: each deploy script can be rerun without duplicate resources; each
has a matching `destroy.sh`; free-tier guardrails and billing alarms are
documented; SSH is restricted to the caller's IP.

### Milestone 3 — Web dashboard
A small read-only web UI showing provider status, instance list, cost notes and
setup links. No secret storage. Should be deployable to Cloudflare Pages free.

### Milestone 4 — Automated checks
CI validates shell syntax, JSON/YAML, Dockerfile build (where possible), and
runs shell unit tests with mocks. No workflow may create real cloud resources
without an explicit manual dispatch and user secrets.

### Milestone 6 — Cross-platform CLI and install wizards
Acceptance: `rust/target/release/usvnc.exe` (or platform binary) builds, `doctor`
reports the host tools correctly, `init` writes `.env` once, and both wizards
work on their target OS. The account guide opens pages but never handles secrets.

### Milestone 5 — Optional Neon integration
Only if the user confirms "Neon" means Neon serverless Postgres: store instance
metadata and audit events in Neon free tier. Not required for the core app.

## Agent entry points

- `AGENTS.md` — generic rules for any coding agent.
- `CLAUDE.md` — Claude Code specific notes.
- `GEMINI.md` — Gemini CLI specific notes.
- `agents/README.md` and `agents/programs/*.md` — staged development programs.
- `scripts/agent-task.sh` — runner: `bash scripts/agent-task.sh claude agents/programs/01-harden-core.md`.

Keep every change inside these boundaries, update this handoff when state
changes, and never mark a milestone complete without real verification output.
