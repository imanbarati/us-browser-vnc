# Program 06 — Tests and CI without cloud side effects

Goal: make the repo trustworthy for other coding agents and contributors.

Tasks:
1. Add shell unit tests (bats or plain sh with assertions) for bootstrap and provider dry runs.
2. Add a GitHub Actions workflow `validate.yml` running syntax checks, JSON parsing,
   YAML parsing and `docker build` if feasible on the runner.
3. Ensure no workflow can create AWS/OCI/GitHub resources without `workflow_dispatch`
   and explicit user-provided secrets.
4. Add a checklist to `handoff.md` mapping tests to milestones.

Acceptance:
- CI passes on a pushed commit.
- No real cloud API calls in CI.
- False claims of verification are prohibited; report exact commands and outputs.
