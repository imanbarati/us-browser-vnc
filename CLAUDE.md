# Claude Code notes

Project: `us-browser-vnc` — remote Chromium via noVNC on free-tier US VMs.

Start with `handoff.md`, then `AGENTS.md`. Use `/ship` only when the user asks
for a PR; do not open accounts or enter credentials.

Useful commands:

```bash
bash -n scripts/*.sh providers/*/*.sh docker/entrypoint.sh   # syntax (use find for recursion)
python -c "import json;json.load(open('providers/codespaces/devcontainer.json'))"
docker compose config -q        # when Docker is installed
docker compose up -d --build    # only with user's explicit approval
```

Do not run `providers/*/deploy.sh` automatically. They create billable or
free-tier resources and require the user's configured CLI credentials.

When asked to continue development, pick the next unchecked milestone in
`handoff.md`, read its program file in `agents/programs/`, implement it, verify
it with real output, then update the handoff and commit if asked.
