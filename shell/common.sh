# Helpers shared by macOS and Linux.

# Fetch the latest helpers from GitHub, reinstall, and reload them in this shell.
helpers-sync() {
  "$HOME/.config/shell-helpers/install.sh" && . "$HOME/.config/shell-helpers/common.sh"
}

# Copy shell config files into ~/.shell-config-backups/<timestamp>/
backup-shell-config() {
  dest="$HOME/.shell-config-backups/$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$dest" || return 1
  copied=0
  for f in .bashrc .bash_profile .bash_login .bash_logout .bash_aliases .profile \
           .zshrc .zprofile .zshenv .zlogin .zlogout .inputrc; do
    if [ -f "$HOME/$f" ]; then
      cp -p "$HOME/$f" "$dest/" && copied=$((copied + 1))
    fi
  done
  echo "Backed up $copied file(s) to $dest"
}

# Claude Code
alias yolo-sonnet='claude --dangerously-skip-permissions --model sonnet'
alias yolo-opus='claude --dangerously-skip-permissions --model opus'
alias yolo-fable='claude --dangerously-skip-permissions --model fable'

# SSH
alias ssh-git='ssh-add ~/.ssh/id_rsa'

# wget with a browser-like user agent
alias wget-real='wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36" --header="Accept-Language: en-US,en;q=0.9"'
