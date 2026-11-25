# Development programs

Each file is a self-contained task prompt for Claude Code, Gemini CLI or another
coding agent. Run them in order. They are deliberately scoped so one agent can
finish a milestone without touching accounts or secrets.

| Program | Goal |
|---|---|
| `01-harden-core.md` | Make the Docker/noVNC/Caddy stack reliable and testable |
| `02-aws-provider.md` | Idempotent AWS provisioning + destroy + free-tier guardrails |
| `03-oracle-provider.md` | Idempotent OCI provisioning + destroy + capacity notes |
| `04-codespaces-provider.md` | Polish devcontainer and local noVNC startup |
| `05-web-dashboard.md` | Read-only status dashboard deployable to Cloudflare Pages |
| `06-tests-ci.md` | Shell tests and CI that never creates cloud resources |
| `07-neon-optional.md` | Optional Neon free Postgres metadata store |

Runner:

```bash
bash scripts/agent-task.sh claude agents/programs/01-harden-core.md
bash scripts/agent-task.sh gemini agents/programs/01-harden-core.md
```

The agent CLIs must already be installed and authenticated by the user.
