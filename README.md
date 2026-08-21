# Dotfiles

Declarative dotfiles managed with **Nix + home-manager**.

## Quick Start

```bash

# 1. Install manual tools (see Manual Installs section below)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash


# Packages for Ubuntu are available from the fish PPA, and can be installed using the following commands:
sudo apt-add-repository ppa:fish-shell/release-4
sudo apt update
sudo apt install fish

# Add Fish to Valid Shells: Make sure Fish is listed in /etc/shells. You can do this by running:
echo $(command -v fish) | sudo tee -a /etc/shells

# Change Default Shell
# Run the Command: Use the following command to change your default shell to Fish:
chsh -s $(command -v fish)

# Log Out and Back In: For the changes to take effect, log out of your user account and then log back in.
# Verification: To verify that the change was successful, open a terminal and type:
echo $SHELL

# Mise fish shell for version management
curl https://mise.run/fish | sh
# Installs mise and adds activation to ~/.config/fish/config.fish

curl -fsSL https://bun.sh/install | bash # try AUBE: mise use -g aube

# Install Starship
# Install the latest version for your system:
curl -sS https://starship.rs/install.sh | sh

# Set up your shell to use Starship: Fish
# Add the following to the end of ~/.config/fish/config.fish:
starship init fish | source

# Install Opencode
curl -fsSL https://opencode.ai/install | bash

# Reload shell
exec $SHELL

# Install Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar xzf nvim-linux-x86_64.tar.gz -C /opt/
# add nvim to fish path
set -U fish_user_paths /opt/nvim-linux-x86_64/bin $fish_user_paths

# Reload shell
exec $SHELL

# Install Lunarvim

# install prerequisites with miso 
mise use -g make
mise use -g python
mise use -g node
mise use -g rust
mise use -g ripgrep


# install gcc with build-essential
sudo apt install -y build-essential

# Install Lunarvim in fish shell
curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh | bash

# Reload shell
exec $SHELL

## Note: LUNAR vim errors with treessitter.

# 2. Install Nix (if not installed)
# Single-user installation
# Install Nix via the single-user installation:

curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --no-daemon

# Above command will perform a single-user installation of Nix, meaning that nix is owned by the invoking user. You should run this under your usual user account, not as root. The script will invoke sudo to create /nix if it doesn’t already exist.

# Log Out and Back In: For the changes to take effect, log out of your user account and then log back in.

# 2.1 Add the appropriate Home Manager channel. If you are following Nixpkgs master or an unstable channel you can run

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

# 2.2 Run the Home Manager installation command and create the first Home Manager generation:

nix-shell '<home-manager>' -A install

# 3. Enable flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# 4. Clone dotfiles
git clone https://github.com/concatenateline/.dotfiles ~/.dotfiles
cd ~/.dotfiles

# 5. Prepare an initial Home Manager configuration for your logged in user, you can run the Home Manager init command directly from its flake.

nix run home-manager/master -- init --switch

# 5.1 Apply home-manager config
nix run home-manager/master -- switch --flake ~/.config/home-manager

# 6. Reload shell
exec $SHELL
```

## What Nix Installs (automatic)

**Programs + configs** — installed via `modules/packages.nix` and `modules/programs.nix`:

| Category | Tools |
|----------|-------|
| CLI | git, delta, diff-so-fancy, fzf, ripgrep, bat, eza, jq, curl, wget, unzip, tree, htop |
| Languages | go |
| Utilities | docker-compose, lazygit |
| Shell | tmux (with catppuccin, sensible, yank, resurrect, continuum plugins) |
| Prompt | starship (gradient theme) |
| Shell config | fish (PATH, nvm, mise, abbrs) |

## Manual Installs

These tools are **not managed by Nix** and must be installed separately.

### Required (before home-manager switch)

| Tool | Install Command | Purpose |
|------|----------------|---------|
| Nix | `sh <(curl -L https://nixos.org/nix/install) --no-daemon` | Foundation for home-manager |
| nvm | `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh \| bash` | Node version manager |
| mise | `curl https://mise.run \| sh` | Language version manager (ruby, python, etc.) |
| Neovim | `curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && sudo tar xzf nvim-linux-x86_64.tar.gz -C /opt/` | Text editor |
| opencode | `npm i -g opencode` | AI coding assistant |
| bun | `curl -fsSL https://bun.sh/install \| bash` | JS runtime/bundler |

### Optional (install if you use them)

| Tool | Install Command | Purpose |
|------|----------------|---------|
| LunarVim | `LVIM_BRANCH/master bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/master/utils/installer/install.sh)` | Neovim IDE layer |
| Kitty | `sudo apt install kitty` or [AppImage](https://sw.kovidgoyal.net/kitty/binary/) | GPU terminal emulator |

> **Note:** If these aren't installed, the config symlinks from `dotfiles.nix` are harmless but unused.

## Config Symlinks (automatic via home-manager)

All config files are managed by `modules/dotfiles.nix`. No manual symlinks needed.

| Config | Symlink Target |
|--------|---------------|
| `~/.config/opencode/` | 6 files + 4 dirs → `~/.dotfiles/opencode/` |
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
