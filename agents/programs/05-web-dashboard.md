# Program 05 — Read-only web dashboard

Goal: build a small web UI that makes this feel like an actual product.

Tasks:
1. Choose a dependency-light stack (plain HTML/CSS/JS or TanStack Start if the user approves).
2. Dashboard shows: provider options, free-tier limits, setup commands, US-IP caveat,
   and a health check for a configured noVNC URL (browser-side fetch, no secrets).
3. Deployable to Cloudflare Pages free tier via `wrangler pages deploy dashboard`.
4. Add a GitHub Actions workflow that skips cleanly when Cloudflare secrets are absent.
5. No backend database and no credential storage by default.

Acceptance:
- Local dashboard renders at desktop and 390px with no horizontal overflow.
- Build/deploy config validates; no Cloudflare account action is performed by the agent.
- `handoff.md` milestone 3 updated only after real verification.

Do not: add login forms that collect passwords, or claim ban immunity.
