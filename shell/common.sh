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

# Terraform
alias tf='terraform'

# yt-dlp audio downloads
alias mp3yt='yt-dlp -x --audio-format mp3 --yes-playlist'
alias flacyt='yt-dlp -x --audio-format flac --yes-playlist'

# SSH
alias ssh-git='ssh-add ~/.ssh/id_rsa'

# Add every private key in ~/.ssh to the ssh-agent for 8 hours (and the macOS keychain).
ssh-all() {
  for _sh_pub in "$HOME"/.ssh/*.pub; do
    [ -f "$_sh_pub" ] || continue
    _sh_key=${_sh_pub%.pub}
    [ -f "$_sh_key" ] || continue
    if [ "$(uname)" = "Darwin" ]; then
      ssh-add -t 8h --apple-use-keychain "$_sh_key"
    else
      ssh-add -t 8h "$_sh_key"
    fi
  done
  unset _sh_pub _sh_key
}

# wget with a browser-like user agent
alias wget-real='wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36" --header="Accept-Language: en-US,en;q=0.9"'

# Download a URL to a random 10-character name, keeping its file extension.
dl() {
  ext=$(basename "${1%%\?*}" | grep -oE '\.[^./?]+$' | cut -c2-)
  [ -z "$ext" ] && ext="bin"
  name="$(LC_ALL=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 10).$ext"
  wget -O "$name" "$1" && echo "Saved as $name"
}

# flick: send a file over the LAN (receiver listens for a UDP broadcast, then pulls over TCP)
flick-receive() {
  local a=$(socat -u UDP-RECV:19123,null-eof -)
  socat -u TCP:"$a" CREATE:"$1"
}

flick-send() {
  local p=$((RANDOM % 10000 + 40000)) i b
  timeout 5 socat -u FILE:"$1" TCP-LISTEN:$p,reuseaddr &
  read i b <<< "$(ip -o -4 a | awk '/brd (10\.0|192\.168)\./{print $4, $6; exit}')"
  socat -u - UDP-DATAGRAM:$b:19123,broadcast <<< "${i%/*}:$p"
  python3 -c "import socket as S;s=S.socket(S.AF_INET,S.SOCK_DGRAM);s.setsockopt(S.SOL_SOCKET,S.SO_BROADCAST,1);s.sendto(b'',('$b',19123))"
  wait
}
