# Program 04 — Codespaces devcontainer polish

Goal: make the temporary noVNC codespace reliable for development/testing.

Tasks:
1. Make `providers/codespaces/start.sh` idempotent: safe to rerun, no duplicate processes.
2. Use a non-root user where possible; document why Chromium still needs `--no-sandbox`.
3. Generate a random VNC password per codespace and print it once, never write it to git.
4. Add a clear notice in the README that Codespaces is not a general browsing proxy.
5. Validate `devcontainer.json` parses and `forwardPorts` includes 6080.

Acceptance:
- JSON parses, `bash -n` passes.
- No codespace is created by the agent; the user does that.
