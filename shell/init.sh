# Entry point sourced from ~/.bashrc / ~/.zshrc. Works in bash and zsh.
: "${SHELL_HELPERS_DIR:?SHELL_HELPERS_DIR not set}"

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

. "$SHELL_HELPERS_DIR/shell/common.sh"
case "$(uname -s)" in
  Darwin) [ -f "$SHELL_HELPERS_DIR/shell/macos.sh" ] && . "$SHELL_HELPERS_DIR/shell/macos.sh" ;;
  Linux)  [ -f "$SHELL_HELPERS_DIR/shell/linux.sh" ] && . "$SHELL_HELPERS_DIR/shell/linux.sh" ;;
esac
