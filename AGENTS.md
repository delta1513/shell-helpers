# AGENTS.md

## What this repo is

Personal shell helpers (aliases, functions, exports) installed on the owner's macOS and Linux machines, in both bash and zsh. Keep it simple: one helpers file and one installer.

- `shell/common.sh`: every alias, function and export. Sourced on shell startup.
- `install.sh`: clones this repo into a temp dir under `/tmp`, copies `common.sh` and `install.sh` to `~/.config/shell-helpers/`, deletes the clone, and adds one marked block (`# >>> shell-helpers >>>` … `# <<< shell-helpers <<<`) to `~/.bashrc` / `~/.zshrc`. It must stay idempotent.
- `README.md`: setup instructions and a one-line list of every helper.

Machines pull from `main` via `helpers-sync`, so whatever lands on `main` ships to every machine.

## Adding or changing a helper

1. Edit `shell/common.sh`, grouped under a short comment.
2. Add or update its line in the README's **Helpers** list.
3. Test it (see below), commit, push.

Rules for `common.sh`:
- Must work in both bash and zsh, and on macOS (BSD tools, bash 3.2) and Linux (GNU tools). Watch for `sed -i`, `date`, `readlink -f`, `tr` on binary input (needs `LC_ALL=C` on macOS), and `nproc` (use `getconf _NPROCESSORS_ONLN`).
- Prefer a function over an alias that defines a function; don't leak global helper names like `f`.
- Unset any temporary variables used at load time.
- No OS-specific files or `bin/` directory unless the owner asks for them.

## Testing

Test in a throwaway `HOME` so nothing real is touched. To test unpushed work, point the installer at the local checkout:

```bash
H=$(mktemp -d)
SHELL_HELPERS_REPO="file://$PWD" SHELL_HELPERS_BRANCH="$(git branch --show-current)" HOME=$H bash install.sh
HOME=$H bash -ic 'type helpers-sync && alias'
```

The installer clones committed state, so commit before testing it. Run it twice and check the rc file has only one marked block.
