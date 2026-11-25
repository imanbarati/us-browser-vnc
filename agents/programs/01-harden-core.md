# Program 01 — Harden the core noVNC stack

Goal: make the Docker stack usable and verifiable without touching any cloud account.

Context: read `handoff.md` and `AGENTS.md`. Docker may not be installed locally;
if it is not, say so and do not claim a build succeeded.

Tasks:
1. Add a healthcheck to the `browser` service that checks `http://localhost:6080/vnc.html`.
2. Make `docker/entrypoint.sh` fail clearly when `VNC_PASSWORD` is unset or too short,
   and avoid printing the password to logs.
3. Verify the noVNC web root path for the Debian package and keep the check portable.
4. Add `restart` and log rotation notes; ensure Chromium does not run as root.
5. Add a `make local` target or `scripts/local-check.sh` that runs all local syntax checks
   and `docker compose config -q` when Docker exists.
6. Make `scripts/bootstrap.sh` idempotent: it must not overwrite an existing `.env`,
   must support non-interactive use via `VNC_PASSWORD` and `DOMAIN`, and must print
   the final URL only.

Acceptance:
- `bash -n` passes on all shell files.
- `docker compose config -q` passes when Docker is available; otherwise the gap is stated.
- No secrets are committed and no cloud resource is created.
- `handoff.md` milestone 1 status is updated only after a real local Docker run.

Do not: install cloud CLIs, create accounts, or fetch credentials.
