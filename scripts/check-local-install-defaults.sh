#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

check_contains() {
  local file="$1"
  local expected="$2"

  if ! grep -Fq "$expected" "$ROOT/$file"; then
    echo "Expected $file to contain: $expected" >&2
    return 1
  fi
}

check_absent() {
  local file="$1"
  local forbidden="$2"

  if grep -Fq "$forbidden" "$ROOT/$file"; then
    echo "Expected $file not to contain: $forbidden" >&2
    return 1
  fi
}

check_contains "scripts/install-codex-skills.sh" 'DEST="${CODEX_HOME:-$ROOT/.codex}/skills"'
check_absent "scripts/install-codex-skills.sh" '$HOME/.codex'

check_contains "scripts/install-codex-prompts.sh" 'DEST="${CODEX_HOME:-$ROOT/.codex}/prompts"'
check_absent "scripts/install-codex-prompts.sh" '$HOME/.codex'

check_contains "scripts/install-claude-commands.sh" 'DEST="${CLAUDE_COMMANDS_DIR:-$ROOT/.claude/commands}"'
check_absent "scripts/install-claude-commands.sh" '$HOME/.claude'

check_contains ".gitignore" '.claude/'

echo "Local install defaults are project scoped."
