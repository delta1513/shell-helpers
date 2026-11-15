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

- `shell/common.sh`: helpers for every machine
- `shell/macos.sh`, `shell/linux.sh`: OS-specific helpers
- `bin/`: standalone scripts, symlinked into `~/.local/bin`
- `install.sh`: idempotent installer; adds one marked block to `~/.bashrc` / `~/.zshrc`
