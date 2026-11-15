# Helpers shared by macOS and Linux.

# Fetch the latest helpers from GitHub, reinstall, and reload them in this shell.
helpers-sync() {
  "$HOME/.config/shell-helpers/install.sh" && . "$HOME/.config/shell-helpers/common.sh"
}

# Build with half the available cores (at least 1).
_sh_cores=$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 2)
export MAKEFLAGS="-j$(( _sh_cores / 2 > 0 ? _sh_cores / 2 : 1 ))"
unset _sh_cores

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
alias yolo-haiku='claude --model haiku --dangerously-skip-permissions'
alias yolo-opus='claude --dangerously-skip-permissions --model opus'
alias yolo-fable='claude --dangerously-skip-permissions --model fable'

# SSH
alias ssh-git='ssh-add ~/.ssh/id_rsa'

# wget with a browser-like user agent
alias wget-real='wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36" --header="Accept-Language: en-US,en;q=0.9"'

# Download a URL to a random 10-character name, keeping its file extension.
dl() {
  ext=$(basename "${1%%\?*}" | grep -oE '\.[^./?]+$' | cut -c2-)
  [ -z "$ext" ] && ext="bin"
  name="$(LC_ALL=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 10).$ext"
  wget -O "$name" "$1" && echo "Saved as $name"
}
