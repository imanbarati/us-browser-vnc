#!/usr/bin/env bash
# Opens provider signup pages and prints a guided checklist. Never asks for or
# stores credentials. The user completes signup in their own browser.
set -euo pipefail
provider="${1:-aws}"
case "$provider" in
  aws) url="https://signin.aws.amazon.com/signup" ;;
  oracle) url="https://www.oracle.com/cloud/free/" ;;
  github) url="https://github.com/codespaces" ;;
  cloudflare) url="https://dash.cloudflare.com/sign-up" ;;
  *) echo "Use: aws | oracle | github | cloudflare" >&2; exit 1 ;;
esac
echo "Opening $url"
echo "Checklist: create ONE account, enable MFA, accept the terms, then configure the CLI yourself."
echo "Do not paste passwords or verification codes into chat or files."
if command -v xdg-open >/dev/null 2>&1; then xdg-open "$url" >/dev/null 2>&1 || true
elif command -v open >/dev/null 2>&1; then open "$url" >/dev/null 2>&1 || true
fi
