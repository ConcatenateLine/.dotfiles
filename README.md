# Dotfiles

Declarative dotfiles managed with **Nix + home-manager**.

## Quick Start

```bash
git clone https://github.com/concatenateline/.dotfiles ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
exec ~/.nix-profile/bin/fish  # or log out and back in after the chsh step
```

`bootstrap.sh` is **idempotent** — safe to re-run at any time. It:

1. Installs Nix (single-user, `--no-daemon`) if missing
2. Enables flakes in `~/.config/nix/nix.conf` if absent
3. Clones this repo to `~/.dotfiles` (skipped when run from inside it)
4. Applies home-manager: `nix run home-manager/master -- switch --flake ~/.dotfiles/home-manager -b backup`
5. Adds `~/.nix-profile/bin/fish` to `/etc/shells` and sets it as your login shell (sudo-prompted)

### ⚠️ Important: Configure Username

Before running `bootstrap.sh`, you **must** update the hardcoded `username` in the following configuration files to match your current system username:

```bash
# Get your current username
echo $USER
# or
whoami
```

**Files to update:**
- `home-manager/home.nix` - Update `home.username` and `home.homeDirectory` (lines 10-11)
- `home-manager/flake.nix` - Update `homeConfigurations."line"` (line 16)
- `fish/config.fish` - Update user-specific paths (lines 8, 12, 37, 41, 44)
- `devin/mcp_config.json` - Update user-specific paths (line 20)
- `applications/windsurf/mcp_config.json` - Update user-specific paths (line 13)

**Quick find-and-replace:**
```bash
# Replace all occurrences of line with your username
find ~/.dotfiles -type f -exec sed -i 's/line/YOUR_USERNAME/g' {} +
```

### Flags

| Flag | Effect |
|------|--------|
| `--no-chsh` | Skip the login-shell steps |
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
| CLI | git, delta, diff-so-fancy, fzf, ripgrep, bat, eza, jq, curl, wget, unzip, tree, htop, fd, tree-sitter |
| Languages / toolchains | go, gnumake, python3, nodejs, rustc, gcc |
| Version manager | mise |
| Editor | neovim 0.12.x (LazyVim, evergarden theme) |
| AI assistant | opencode |
| Utilities | docker-compose, lazygit |
| Shell | fish (mise activation, PATH, abbrs), tmux (catppuccin, sensible, yank, resurrect, continuum plugins) |
| Prompt | starship |

> **Neovim version:** LazyVim requires Neovim **>= 0.11.2**, so `neovim` comes from
> `nixpkgs-unstable` (0.12.6). The `nixpkgs-lvim` input that pinned 0.10.x for
> LunarVim has been removed.

## Manual Steps

Everything is automated except what genuinely needs your hands:

| Step | How | Why |
|------|-----|-----|
| Nix bootstrap | automatic (`bootstrap.sh`) | Foundation for home-manager |
| Login shell | sudo prompt during `bootstrap.sh` (skip with `--no-chsh`) | `chsh`/`/etc/shells` are system-level |
| LazyVim plugins | first `nvim` launch | lazy.nvim clones and installs the plugins on the first run |

Log out and back in after the chsh step. Verify with `echo $SHELL`.

## Config Symlinks (automatic via home-manager)

All config files are managed by `modules/dotfiles.nix`. No manual symlinks needed.

| Config | Symlink Target |
|--------|---------------|
| `~/.config/opencode/` | copied from `~/.dotfiles/opencode/` |
| `~/.config/devin/` | 3 files → `~/.dotfiles/devin/` |
| `~/.config/nvim/` | → `~/.dotfiles/nvim/` (live symlink, see note) |
| `~/.config/kitty/kitty.conf` | → `~/.dotfiles/kitty/kitty.conf` |
| `~/.config/git/config` | → Nix store (generated) |
| `~/.config/fish/config.fish` | → Nix store (generated) |
| `~/.config/starship.toml` | → Nix store (generated) |
| `~/.config/tmux/tmux.conf` | → Nix store (generated) |

> **Why `~/.config/nvim` is a live symlink:** lazy.nvim writes `lazy-lock.json` into
> the config directory. A Nix store copy is read-only, so the link points at the
> repository instead and the lock file stays part of the dotfiles. The link is
> created by an activation script (a path baked into a Nix string would be copied
> into the store). Set `DOTFILES_REPO` if the checkout is not in `~/.dotfiles`.

## Directory Structure

```
dotfiles/
├── bootstrap.sh                # Idempotent one-shot setup (with logging)
├── home-manager/
│   ├── flake.nix               # Flake definition
│   ├── flake.lock              # Pinned versions
│   ├── home.nix                # Entry point
│   └── modules/
│       ├── packages.nix        # Packages (mise, opencode, neovim, toolchains)
│       ├── programs.nix        # Git, fish, tmux, starship
│       └── dotfiles.nix        # Symlinks for opencode/devin/nvim/kitty
├── opencode/                   # OpenCode config files
├── devin/                      # Devin config files
├── nvim/                       # Neovim config (LazyVim)
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
- **[Neovim / LazyVim](nvim/README.md)** — Neovim IDE layer
- **[Starship](starship/README.md)** — Prompt theme
- **[Tmux](tmux/README.md)** — Terminal multiplexer
- **[Kitty](kitty/README.md)** — Terminal emulator
