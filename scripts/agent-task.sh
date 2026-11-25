#!/usr/bin/env bash
# Runs one development program with the selected coding agent CLI.
# The CLIs must be installed and authenticated by the user.
set -euo pipefail

AGENT="${1:-}"
TASK="${2:-}"
if [ -z "$AGENT" ] || [ -z "$TASK" ]; then
  echo "Usage: bash scripts/agent-task.sh <claude|gemini> <task-file.md>" >&2
  exit 1
fi
[ -f "$TASK" ] || { echo "Task file not found: $TASK" >&2; exit 1; }

PROMPT="$(cat "$TASK")"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

case "$AGENT" in
  claude)
    command -v claude >/dev/null || { echo "claude CLI not installed" >&2; exit 1; }
    claude -p "$PROMPT"
    ;;
  gemini)
    command -v gemini >/dev/null || { echo "gemini CLI not installed" >&2; exit 1; }
    gemini -p "$PROMPT"
    ;;
  *)
    echo "Unknown agent: $AGENT (use claude or gemini)" >&2
    exit 1
    ;;
esac
