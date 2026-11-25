# Gemini CLI notes

Project: `us-browser-vnc` — remote Chromium via noVNC on free-tier US VMs.

Start with `handoff.md`, then `AGENTS.md`. Same boundaries as Claude: no account
automation, no stored credentials, no ban-evasion claims.

Suggested invocation:

```bash
gemini -p "$(cat agents/programs/01-harden-core.md)"
```

The runner script does this for you:

```bash
bash scripts/agent-task.sh gemini agents/programs/01-harden-core.md
```

Gemini should not assume Docker or cloud CLIs are installed. Check with
`command -v docker`, `command -v aws`, `command -v oci` before relying on them,
and report missing tools rather than inventing successful output.
