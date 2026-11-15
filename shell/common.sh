# Helpers shared by macOS and Linux.

# Pull the latest helpers, re-run the installer, and reload them in this shell.
helpers-sync() {
  "$SHELL_HELPERS_DIR/install.sh" "$@" && . "$SHELL_HELPERS_DIR/shell/common.sh"
}

# Claude Code
alias yolo-sonnet='claude --dangerously-skip-permissions --model sonnet'
alias yolo-opus='claude --dangerously-skip-permissions --model opus'
alias yolo-fable='claude --dangerously-skip-permissions --model fable'

# SSH
alias ssh-git='ssh-add ~/.ssh/id_rsa'

# wget with a browser-like user agent
alias wget-real='wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36" --header="Accept-Language: en-US,en;q=0.9"'
