#!/usr/bin/env bash
# Install or re-sync shell-helpers. Safe to run repeatedly.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MARK_BEGIN="# >>> shell-helpers >>>"
MARK_END="# <<< shell-helpers <<<"

# Pull latest changes unless --no-pull or there are local edits.
if [ "${1:-}" != "--no-pull" ]; then
  if [ -z "$(git -C "$REPO_DIR" status --porcelain)" ]; then
    git -C "$REPO_DIR" pull --ff-only || echo "warning: git pull failed; using local copy" >&2
  else
    echo "note: local changes present; skipping git pull" >&2
  fi
fi

block="$MARK_BEGIN
export SHELL_HELPERS_DIR=\"$REPO_DIR\"
. \"\$SHELL_HELPERS_DIR/shell/common.sh\"
$MARK_END"

case "$(uname -s)" in
  Darwin) default_rc="$HOME/.zshrc" ;;
  *)      default_rc="$HOME/.bashrc" ;;
esac
[ -f "$default_rc" ] || touch "$default_rc"

for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  [ -f "$rc" ] || continue
  # Drop any previous block so the repo path stays current.
  tmp="$(mktemp)"
  awk -v b="$MARK_BEGIN" -v e="$MARK_END" '$0==b{skip=1;next} $0==e{skip=0;next} !skip' "$rc" > "$tmp"
  printf '%s\n' "$block" >> "$tmp"
  cat "$tmp" > "$rc"; rm -f "$tmp"
  echo "configured $rc"
done

echo "Done. Open a new shell, or run: helpers-sync"
