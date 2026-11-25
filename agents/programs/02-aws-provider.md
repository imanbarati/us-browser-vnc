# Program 02 — AWS provider hardening

Goal: turn `providers/aws/deploy.sh` into an idempotent, safe, one-VM provisioner.

Tasks:
1. Detect existing security group / key pair / instance by tag and reuse them.
2. Restrict SSH ingress to the caller's public IP; never open 22 to 0.0.0.0/0.
3. Add a billing alarm (CloudWatch) for the account, documented as optional but recommended.
4. Add `providers/aws/destroy.sh` that terminates only instances tagged `us-browser-vnc`.
5. Add a `--dry-run` mode that prints commands without calling AWS.
6. Document free-tier limits and 12-month expiry in `providers/aws/README.md`.

Acceptance:
- `bash -n` passes; `--dry-run` works without AWS credentials.
- No real AWS API call is made during development.
- No keys, account IDs or tokens are written to the repo.
