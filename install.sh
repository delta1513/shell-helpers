#!/usr/bin/env bash
# Install or re-sync shell-helpers. Safe to run repeatedly.
# Clones the repo into a temporary directory, copies the helpers into
# ~/.config/shell-helpers, then deletes the clone.
set -euo pipefail

REPO_URL="${SHELL_HELPERS_REPO:-https://github.com/delta1513/shell-helpers.git}"
BRANCH="${SHELL_HELPERS_BRANCH:-main}"
INSTALL_DIR="$HOME/.config/shell-helpers"
MARK_BEGIN="# >>> shell-helpers >>>"
MARK_END="# <<< shell-helpers <<<"

tmp="$(mktemp -d "${TMPDIR:-/tmp}/shell-helpers.XXXXXX")"
trap 'rm -rf "$tmp"' EXIT

git clone --quiet --depth 1 --branch "$BRANCH" "$REPO_URL" "$tmp/repo"

mkdir -p "$INSTALL_DIR"
cp "$tmp/repo/shell/common.sh" "$INSTALL_DIR/common.sh"
cp "$tmp/repo/install.sh" "$INSTALL_DIR/install.sh"
chmod +x "$INSTALL_DIR/install.sh"

block="$MARK_BEGIN
[ -f \"\$HOME/.config/shell-helpers/common.sh\" ] && . \"\$HOME/.config/shell-helpers/common.sh\"
$MARK_END"

case "$(uname -s)" in
  Darwin) default_rc="$HOME/.zshrc" ;;
  *)      default_rc="$HOME/.bashrc" ;;
esac
[ -f "$default_rc" ] || touch "$default_rc"

for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  [ -f "$rc" ] || continue
  # Replace any previous block so it stays current.
  new="$tmp/rc"
  awk -v b="$MARK_BEGIN" -v e="$MARK_END" '$0==b{skip=1;next} $0==e{skip=0;next} !skip' "$rc" > "$new"
  printf '%s\n' "$block" >> "$new"
  cat "$new" > "$rc"
  echo "configured $rc"
done

echo "Installed to $INSTALL_DIR. Open a new shell, or run: helpers-sync"
