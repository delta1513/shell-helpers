#!/usr/bin/env bash
# Install or re-sync shell-helpers. Safe to run repeatedly.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
MARK_BEGIN="# >>> shell-helpers >>>"
MARK_END="# <<< shell-helpers <<<"

case "$(uname -s)" in
  Darwin) OS=macos ;;
  Linux)  OS=linux ;;
  *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

# Pull latest changes if this is a git checkout with a clean tree.
if [ "${1:-}" != "--no-pull" ] && git -C "$REPO_DIR" rev-parse --git-dir >/dev/null 2>&1; then
  if [ -z "$(git -C "$REPO_DIR" status --porcelain)" ]; then
    git -C "$REPO_DIR" pull --ff-only || echo "warning: git pull failed; continuing with local copy" >&2
  else
    echo "note: local changes present; skipping git pull" >&2
  fi
fi

# Symlink scripts in bin/ into ~/.local/bin.
mkdir -p "$BIN_DIR"
for f in "$REPO_DIR"/bin/*; do
  [ -f "$f" ] || continue
  chmod +x "$f"
  target="$BIN_DIR/$(basename "$f")"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.bak"
    echo "backed up existing $target -> $target.bak"
  fi
  ln -sfn "$f" "$target"
done

# Add a sourcing block to rc files (only once).
block="$MARK_BEGIN
export SHELL_HELPERS_DIR=\"$REPO_DIR\"
[ -f \"\$SHELL_HELPERS_DIR/shell/init.sh\" ] && . \"\$SHELL_HELPERS_DIR/shell/init.sh\"
$MARK_END"

for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  # Only touch .zshrc on macOS or if it already exists; same for .bashrc on Linux.
  if [ ! -f "$rc" ]; then
    case "$rc:$OS" in
      *.zshrc:macos|*.bashrc:linux) touch "$rc" ;;
      *) continue ;;
    esac
  fi
  if grep -qF "$MARK_BEGIN" "$rc"; then
    # Replace existing block so a moved repo path gets updated.
    tmp="$(mktemp)"
    awk -v b="$MARK_BEGIN" -v e="$MARK_END" '
      $0==b{skip=1; next} $0==e{skip=0; next} !skip' "$rc" > "$tmp"
    cat "$tmp" > "$rc"; rm -f "$tmp"
  fi
  printf '\n%s\n' "$block" >> "$rc"
  echo "configured $rc"
done

echo "shell-helpers installed for $OS. Open a new shell, or run: . \"$REPO_DIR/shell/init.sh\""
