# Program 07 — Optional Neon metadata store

Only proceed if the user confirms "Neon" means Neon serverless Postgres. This is
optional and must not become a dependency of the core app.

Tasks:
1. Document what would be stored: instance labels, provider, region, creation time,
   last-checked status. No credentials, no browsing history, no personal data.
2. Add a schema file and an example connection using `DATABASE_URL` from environment.
3. Keep a no-database fallback so the app works without Neon.
4. Document Neon free-tier limits and that this is not required for noVNC.

Acceptance:
- Core app still works with the Neon code removed.
- No connection string or secret is committed.
- User confirmation is recorded in `handoff.md` before any code is added.
