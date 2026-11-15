# shell-helpers

My aliases and functions for macOS and Linux (bash and zsh).

## Setup

```bash
curl -fsSL https://raw.githubusercontent.com/delta1513/shell-helpers/main/install.sh | bash
```

Open a new shell. From then on, run `helpers-sync` to fetch the latest helpers and reload them.

The installer clones the repo into a temporary directory, copies the helpers to `~/.config/shell-helpers/`, and deletes the clone. Set `SHELL_HELPERS_REPO` (e.g. an SSH URL) or `SHELL_HELPERS_BRANCH` to override the source.

## Helpers

- `helpers-sync`: update and reload these helpers
- `backup-shell-config`: copy your shell rc files to `~/.shell-config-backups/<timestamp>/`
- `yolo-sonnet`, `yolo-opus`, `yolo-fable`: Claude Code with permissions skipped
- `ssh-git`: add `~/.ssh/id_rsa` to the SSH agent
- `wget-real`: `wget` with a browser user agent
- `dl <url>`: download to a random filename, keeping the extension
- `MAKEFLAGS=-j<half your cores>` is exported so `make` builds in parallel

## Layout

- `shell/common.sh`: all aliases and functions
- `install.sh`: idempotent installer; adds one marked block to `~/.bashrc` / `~/.zshrc` that sources `~/.config/shell-helpers/common.sh`
