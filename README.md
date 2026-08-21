# Dotfiles

Declarative dotfiles managed with **Nix + home-manager**.

## Quick Start

```bash
git clone https://github.com/concatenateline/.dotfiles ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh                # add --with-lvim to also install LunarVim
exec ~/.nix-profile/bin/fish  # or log out and back in after the chsh step
```

`bootstrap.sh` is **idempotent** — safe to re-run at any time. It:

1. Installs Nix (single-user, `--no-daemon`) if missing
2. Enables flakes in `~/.config/nix/nix.conf` if absent
3. Clones this repo to `~/.dotfiles` (skipped when run from inside it)
4. Applies home-manager: `nix run home-manager/master -- switch --flake ~/.dotfiles/home-manager -b backup`
5. Adds `~/.nix-profile/bin/fish` to `/etc/shells` and sets it as your login shell (sudo-prompted)
6. Optionally installs LunarVim (`--with-lvim`)

### Flags

| Flag | Effect |
|------|--------|
| `--no-chsh` | Skip the login-shell steps |
| `--with-lvim` | Run the LunarVim (nightly) installer after the switch |
| `--verbose` | Show DEBUG log lines on the console |
| `--debug` | Bash xtrace, written to the log file only |
| `--help` | Usage |

### Logs

Every run writes a timestamped log to `~/.local/state/dotfiles/bootstrap-<timestamp>.log`
(console output is mirrored there; the last 5 logs are kept). On failure the script
prints the failing command, line number, and exit code — check the log for details.

## What Nix Installs (automatic)

**Programs + configs** — via `home-manager/modules/packages.nix` and `modules/programs.nix`:

| Category | Tools |
|----------|-------|
| CLI | git, delta, diff-so-fancy, fzf, ripgrep, bat, eza, jq, curl, wget, unzip, tree, htop |
| Languages / toolchains | go, gnumake, python3, nodejs, rustc, gcc |
| Version manager | mise |
| Editor | neovim (pinned — see note below) |
| AI assistant | opencode |
| Utilities | docker-compose, lazygit |
| Shell | fish (mise activation, PATH, abbrs), tmux (catppuccin, sensible, yank, resurrect, continuum plugins) |
| Prompt | starship |

> **Neovim pin:** `neovim` comes from a second nixpkgs input (`nixos-24.11`, neovim
> 0.10.x) because LunarVim nightly targets Neovim 0.10 while `nixpkgs-unstable` ships
> 0.12. If you don't use LunarVim, swap `nixpkgs-lvim.url` in
> `home-manager/flake.nix` back to unstable and use `pkgs.neovim`.

## Manual Steps

Everything is automated except what genuinely needs your hands:

| Step | How | Why |
|------|-----|-----|
| Nix bootstrap | automatic (`bootstrap.sh`) | Foundation for home-manager |
| Login shell | sudo prompt during `bootstrap.sh` (skip with `--no-chsh`) | `chsh`/`/etc/shells` are system-level |
| LunarVim | `./bootstrap.sh --with-lvim` | Optional; requires nvim 0.10.x (verified automatically) |

Log out and back in after the chsh step. Verify with `echo $SHELL`.

## Config Symlinks (automatic via home-manager)

All config files are managed by `modules/dotfiles.nix`. No manual symlinks needed.

| Config | Symlink Target |
|--------|---------------|
| `~/.config/opencode/` | copied from `~/.dotfiles/opencode/` |
| `~/.config/devin/` | 3 files → `~/.dotfiles/devin/` |
| `~/.config/lvim/config.lua` | → `~/.dotfiles/lvim/config.lua` |
| `~/.config/kitty/kitty.conf` | → `~/.dotfiles/kitty/kitty.conf` |
| `~/.config/git/config` | → Nix store (generated) |
| `~/.config/fish/config.fish` | → Nix store (generated) |
| `~/.config/starship.toml` | → Nix store (generated) |
| `~/.config/tmux/tmux.conf` | → Nix store (generated) |

## Directory Structure

```
dotfiles/
├── bootstrap.sh                # Idempotent one-shot setup (with logging)
├── home-manager/
│   ├── flake.nix               # Flake definition (incl. pinned nvim input)
│   ├── flake.lock              # Pinned versions
│   ├── home.nix                # Entry point
│   └── modules/
│       ├── packages.nix        # Packages (mise, opencode, pinned neovim, toolchains)
│       ├── programs.nix        # Git, fish, tmux, starship
│       └── dotfiles.nix        # Symlinks for opencode/devin/lvim/kitty
├── opencode/                   # OpenCode config files
├── devin/                      # Devin config files
├── lvim/                       # LunarVim config
├── kitty/                      # Kitty config
├── fish/                       # Fish config (legacy)
├── starship/                   # Starship config (legacy)
├── tmux/                       # Tmux config (legacy)
├── custom-scripts/             # Custom shell scripts
└── install.sh                  # Fallback installer (legacy)
```

## Updating

After changing any `.nix` file:

```bash
cd ~/.dotfiles
git add -N home-manager/      # Stage new files for nix
nix run home-manager/master -- switch --flake ~/.dotfiles/home-manager -b backup
```

Or simply re-run `./bootstrap.sh`.

## Legacy Mode

If home-manager is not available, `install.sh` falls back to direct symlinks:

```bash
chmod +x install.sh
./install.sh
```

## Documentation

- **[Fish Shell](fish/README.md)** — Shell config and functions
- **[LunarVim](lvim/README.md)** — Neovim IDE layer
- **[Starship](starship/README.md)** — Prompt theme
- **[Tmux](tmux/README.md)** — Terminal multiplexer
- **[Kitty](kitty/README.md)** — Terminal emulator
