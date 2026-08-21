#!/usr/bin/env bash
#
# bootstrap.sh — idempotent one-shot setup for these dotfiles (Nix + home-manager).
#
# Usage: ./bootstrap.sh [--no-chsh] [--with-lvim] [--verbose] [--debug] [--help]
#
# Logs: ~/.local/state/dotfiles/bootstrap-<timestamp>.log (last 5 kept)

set -euo pipefail

REPO_URL="https://github.com/concatenateline/.dotfiles"
REPO_DIR=""
NO_CHSH=false
WITH_LVIM=false
VERBOSE=false
DEBUG=false
LOG_KEEP=5
EXPECTED_NVIM_MAJOR=0
EXPECTED_NVIM_MINOR=10
STEP_TOTAL=6

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Idempotent bootstrap for these dotfiles (Nix + home-manager).

Options:
  --no-chsh     Skip adding fish to /etc/shells and changing the login shell
  --with-lvim   Install LunarVim (nightly) after the home-manager switch
  --verbose     Show DEBUG log lines on the console
  --debug       Bash xtrace (set -x), written to the log file only
  --help        Show this help
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --no-chsh)   NO_CHSH=true ;;
    --with-lvim) WITH_LVIM=true ;;
    --verbose)   VERBOSE=true ;;
    --debug)     DEBUG=true ;;
    --help|-h)   usage; exit 0 ;;
    *)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

# ── Logging ───────────────────────────────────────────────────────────────
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/bootstrap-$(date +%Y%m%d-%H%M%S).log"
touch "$LOG_FILE"

# Rotate: keep only the newest $LOG_KEEP logs.
ls -1t "$LOG_DIR"/bootstrap-*.log 2>/dev/null | tail -n +"$((LOG_KEEP + 1))" | xargs -r rm -f --

# --debug: full bash xtrace into the log file only (fd 9, bypasses console tee).
if [ "$DEBUG" = true ]; then
  exec 9>>"$LOG_FILE"
  BASH_XTRACEFD=9
  PS4='[$(date +%H:%M:%S)] ${BASH_SOURCE[0]##*/}:${LINENO}: '
  set -x
fi

# Mirror everything (script + child processes) to console and logfile.
exec > >(tee -a "$LOG_FILE") 2>&1

log() {
  local level="$1"; shift
  local stamp line
  stamp="$(date '+%Y-%m-%d %H:%M:%S')"
  printf -v line '[%s] [%s] %s' "$stamp" "$level" "$*"
  # DEBUG goes to the file always; console only with --verbose.
  if [ "$level" = "DEBUG" ] && [ "$VERBOSE" != true ]; then
    printf '%s\n' "$line" >> "$LOG_FILE"
    return 0
  fi
  if [ -t 1 ]; then
    case "$level" in
      INFO)  printf '\033[0;32m%s\033[0m\n' "$line" ;;
      WARN)  printf '\033[0;33m%s\033[0m\n' "$line" >&2 ;;
      ERROR) printf '\033[0;31m%s\033[0m\n' "$line" >&2 ;;
      *)     printf '%s\n' "$line" ;;
    esac
  else
    printf '%s\n' "$line"
  fi
}

on_error() {
  local rc=$?
  log ERROR "Failed (exit $rc) near line ${LINENO:-?}: ${BASH_COMMAND}"
  log ERROR "Full log: $LOG_FILE"
  exit "$rc"
}
trap on_error ERR

step() {
  local n="$1" desc="$2"; shift 2
  local t0=$SECONDS rc
  log INFO "Step $n/$STEP_TOTAL: $desc"
  if "$@"; then
    log INFO "Step $n/$STEP_TOTAL DONE ($((SECONDS - t0))s): $desc"
  else
    rc=$?
    log ERROR "Step $n/$STEP_TOTAL FAILED (exit $rc): $desc"
    return "$rc"
  fi
}

# ── Steps ─────────────────────────────────────────────────────────────────

install_nix() {
  if command -v nix >/dev/null 2>&1; then
    log INFO "nix found: $(command -v nix) — skipping install"
    return 0
  fi
  log INFO "nix not found — installing (single-user, --no-daemon)"
  curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install -o /tmp/nix-install-bootstrap.sh
  sh /tmp/nix-install-bootstrap.sh --no-daemon
  rm -f /tmp/nix-install-bootstrap.sh
}

source_nix_profile() {
  if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    log DEBUG "sourced $HOME/.nix-profile/etc/profile.d/nix.sh"
  fi
}

enable_flakes() {
  local conf="$HOME/.config/nix/nix.conf"
  mkdir -p "$(dirname "$conf")"
  if grep -q 'experimental-features' "$conf" 2>/dev/null; then
    log INFO "flakes already enabled in $conf — skipping"
    return 0
  fi
  log INFO "enabling flakes in $conf"
  printf 'experimental-features = nix-command flakes\n' >> "$conf"
}

ensure_repo() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
  if [ -f "$script_dir/home-manager/flake.nix" ]; then
    REPO_DIR="$script_dir"
    log INFO "using repo at script location: $REPO_DIR"
    return 0
  fi
  if [ -f "$HOME/.dotfiles/home-manager/flake.nix" ]; then
    REPO_DIR="$HOME/.dotfiles"
    log INFO "using existing clone: $REPO_DIR"
    return 0
  fi
  log INFO "cloning $REPO_URL -> $HOME/.dotfiles"
  git clone "$REPO_URL" "$HOME/.dotfiles"
  REPO_DIR="$HOME/.dotfiles"
}

apply_home_manager() {
  # New/untracked files are invisible to flake evaluation until intent-to-add.
  git -C "$REPO_DIR" add -N home-manager/ 2>/dev/null || true
  nix run home-manager/master -- switch --flake "$REPO_DIR/home-manager" -b backup
}

setup_shell() {
  if [ "$NO_CHSH" = true ]; then
    log INFO "--no-chsh given — skipping login-shell setup"
    return 0
  fi
  local fish_bin="$HOME/.nix-profile/bin/fish"
  if [ ! -x "$fish_bin" ]; then
    log WARN "$fish_bin not found — skipping login-shell setup"
    return 0
  fi
  if grep -qxF "$fish_bin" /etc/shells 2>/dev/null; then
    log INFO "/etc/shells already lists $fish_bin"
  else
    log INFO "appending $fish_bin to /etc/shells (sudo may prompt)"
    echo "$fish_bin" | sudo tee -a /etc/shells >/dev/null
  fi
  if [ "${SHELL:-}" = "$fish_bin" ]; then
    log INFO "login shell already set to $fish_bin"
  else
    log INFO "changing login shell to $fish_bin (sudo may prompt)"
    sudo chsh -s "$fish_bin" "${USER:-$(id -un)}"
  fi
}

install_lunarvim() {
  if [ "$WITH_LVIM" != true ]; then
    log INFO "--with-lvim not given — skipping LunarVim"
    return 0
  fi
  if command -v lvim >/dev/null 2>&1; then
    log INFO "lvim already installed: $(command -v lvim) — skipping"
    return 0
  fi
  local major minor nvim_line
  nvim_line="$(nvim --version | sed -n '1p')"
  major="$(printf '%s' "$nvim_line" | sed -n 's/^NVIM v\([0-9][0-9]*\)\..*/\1/p')"
  minor="$(printf '%s' "$nvim_line" | sed -n 's/^NVIM v[0-9][0-9]*\.\([0-9][0-9]*\).*/\1/p')"
  if [ "$major" != "$EXPECTED_NVIM_MAJOR" ] || [ "$minor" != "$EXPECTED_NVIM_MINOR" ]; then
    log WARN "$nvim_line is not ${EXPECTED_NVIM_MAJOR}.${EXPECTED_NVIM_MINOR}.x — skipping LunarVim install"
    return 0
  fi
  log INFO "nvim ${EXPECTED_NVIM_MAJOR}.${EXPECTED_NVIM_MINOR}.x confirmed — running LunarVim nightly installer"
  bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
}

main() {
  log INFO "bootstrap started — log file: $LOG_FILE"
  step 1 "Check/install Nix" install_nix
  source_nix_profile
  step 2 "Enable flakes" enable_flakes
  step 3 "Locate/clone dotfiles repo" ensure_repo
  step 4 "Apply home-manager configuration" apply_home_manager
  step 5 "Set up login shell" setup_shell
  step 6 "Optional LunarVim install" install_lunarvim
  log INFO "All done. Open a new shell or run: exec $HOME/.nix-profile/bin/fish"
}

main "$@"
