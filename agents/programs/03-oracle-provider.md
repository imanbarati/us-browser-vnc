# Program 03 — Oracle Always Free provider hardening

Goal: make `providers/oracle/deploy.sh` idempotent and capacity-aware.

Tasks:
1. Check for an existing instance with display name `us-browser-vnc` and reuse it.
2. Retry ARM capacity failures with a bounded backoff and a clear message.
3. Document required VCN security-list rules (22 from caller IP, 80/443 public, 6080 optional).
4. Add `providers/oracle/destroy.sh` that terminates only the tagged instance.
5. Add `--dry-run` that prints the OCI command without calling OCI.
6. Update `providers/oracle/README.md` with exact env var examples and capacity caveats.

Acceptance:
- `bash -n` passes; dry run works with no OCI CLI installed.
- No OCI resources created during development and no OCIDs committed.
