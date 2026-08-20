# Dotfiles

Declarative dotfiles managed with **Nix + home-manager**.

## Quick Start

```bash
# 1. Clone
git clone https://github.com/concatenateline/dotfiles ~/.dotfiles
cd ~/.dotfiles

# 2. Install Nix (if not installed)
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# 3. Enable flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# 4. Apply home-manager config
nix run home-manager/master -- switch --flake ~/.config/home-manager

# 5. Reload shell
exec fish
```

## What's Managed

| Tool | Config | Manager |
|------|--------|---------|
| Git | user, delta, diff-so-fancy, merge | `modules/programs.nix` |
| Fish | PATH, nvm, starship, mise, abbrs | `modules/programs.nix` |
| Tmux | prefix, vi mode, catppuccin, plugins | `modules/programs.nix` |
| Starship | gradient theme, sections | `modules/programs.nix` |
| OpenCode | config files, agents, skills | `modules/dotfiles.nix` |
| Devin | MCP, config, rules | `modules/dotfiles.nix` |
| LunarVim | config.lua | `modules/dotfiles.nix` |
| Kitty | kitty.conf | `modules/dotfiles.nix` |

## Packages

Installed via `modules/packages.nix`:

git, delta, diff-so-fancy, fzf, ripgrep, bat, eza, jq, curl, wget, unzip, tree, htop, go, docker-compose, lazygit

## Directory Structure

```
dotfiles/
├── home-manager/
│   ├── flake.nix              # Flake definition
│   ├── flake.lock             # Pinned versions
│   ├── home.nix               # Entry point
│   └── modules/
│       ├── packages.nix       # System packages
│       ├── programs.nix       # Git, fish, tmux, starship
│       └── dotfiles.nix       # Symlinks for opencode/devin/lvim/kitty
├── opencode/                  # OpenCode config files
├── devin/                     # Devin config files
├── lvim/                      # LunarVim config
├── kitty/                     # Kitty config
├── fish/                      # Fish config (legacy)
├── starship/                  # Starship config (legacy)
├── tmux/                      # Tmux config (legacy)
├── custom-scripts/            # Custom shell scripts
└── install.sh                 # Fallback installer
```

## Updating

After changing any `.nix` file:

```bash
cd ~/.dotfiles
git add -N home-manager/      # Stage new files for nix
nix run home-manager/master -- switch --flake ~/.config/home-manager
```

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
