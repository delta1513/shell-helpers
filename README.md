# shell-helpers

My aliases and functions for macOS and Linux (bash and zsh).

## Setup

```bash
curl -fsSL https://raw.githubusercontent.com/delta1513/shell-helpers/main/install.sh | bash
```

# Updating the scripts

Run `helpers-sync`

# Examine the scripts

[shell/common.sh](shell/common.sh)

# Helpers

- `helpers-sync`: fetch the latest helpers, reinstall, and reload them.
- `backup-shell-config`: copy shell rc files into `~/.shell-config-backups/<timestamp>/`.
- `yolo-sonnet`, `yolo-haiku`, `yolo-opus`, `yolo-fable`: aliases for `claude --dangerously-skip-permissions` with a model.
- `tf`: alias for `terraform`.
- `mp3yt`, `flacyt`: yt-dlp audio downloads (mp3 / flac).
- `ssh-git`: add `~/.ssh/id_rsa` to the ssh-agent.
- `ssh-all`: add every private key in `~/.ssh` to the ssh-agent for 8 hours.
- `wget-real`: wget with a browser-like user agent.
- `dl <url>`: download to a random 10-character name, keeping the extension.
- `flick-send <file>` / `flick-receive <dest>`: send a file over the LAN via UDP broadcast discovery + TCP (needs `socat`, `ip`, `python3`).
