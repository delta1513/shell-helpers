# shell-helpers

My aliases, functions and scripts for macOS and Linux (bash and zsh).

## First install

```bash
git clone git@github.com:delta1513/shell-helpers.git ~/shell-helpers
```

```bash
~/shell-helpers/install.sh
```

Then open a new shell.

## Sync

```bash
helpers-sync
```

This pulls the latest changes (skipped if you have local edits), re-runs the installer and reloads the helpers in the current shell. Pass `--no-pull` to skip the pull.

## Layout

- `shell/common.sh`: all aliases and functions (bash and zsh, macOS and Linux)
- `install.sh`: idempotent installer; adds one marked block to `~/.bashrc` / `~/.zshrc` that sources `common.sh`
