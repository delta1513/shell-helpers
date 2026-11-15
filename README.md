# shell-helpers

My aliases and functions for macOS and Linux (bash and zsh).

## Setup

```bash
git clone git@github.com:delta1513/shell-helpers.git ~/shell-helpers
```

```bash
~/shell-helpers/install.sh
```

Open a new shell. From then on, run `helpers-sync` to pull the latest helpers and reload them (`--no-pull` skips the pull).

## Helpers

- `helpers-sync`: update and reload these helpers
- `backup-shell-config`: copy your shell rc files to `~/.shell-config-backups/<timestamp>/`
- `yolo-sonnet`, `yolo-opus`, `yolo-fable`: Claude Code with permissions skipped
- `ssh-git`: add `~/.ssh/id_rsa` to the SSH agent
- `wget-real`: `wget` with a browser user agent

## Layout

- `shell/common.sh`: all aliases and functions
- `install.sh`: idempotent installer; adds one marked block to `~/.bashrc` / `~/.zshrc` that sources `common.sh`
