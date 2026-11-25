# Agent instructions — us-browser-vnc

Read `handoff.md` first. It contains the current state, hard boundaries and
milestones. Follow these rules for every change:

- Work only inside this repository. Do not create cloud accounts, sign in to
  provider consoles, or store credentials. The user owns all accounts.
- Never promise ban immunity or help evade a specific site's or provider's ban.
- Treat datacenter IP reputation as a real limitation; document it honestly.
- Do not commit `.env`, keys, tokens or browser profiles.
- Prefer dependency-free shell/Python/Node code. Keep Docker images small.
- Every script must be idempotent where practical and must print what it does.
- Do not run provisioning scripts during development. Use mocks and dry runs.
- Verify with `bash -n`, JSON/YAML parsing, and real local tests when possible.
- If Docker is unavailable, say so; do not claim the stack was built.
- Update `handoff.md` and the relevant program checklist when a milestone is
  actually verified.

See `CLAUDE.md` or `GEMINI.md` for agent-specific invocation notes.
