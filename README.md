# 🧼 Minimal Dotfiles

Minimal dotfiles setup for tmux, fish, kitty, starship, and LunarVim.

This setup uses direct symlinking to manage dotfiles in your `$HOME` directory.

---

## Install

```bash
git clone https://github.com/concatenateline/dotfiles ~/.dotfiles
cd ~/.dotfiles

# Run the install script to symlink all configs
chmod +x install.sh
./install.sh

# This will create symlinks like:
#  ~/.config/fish/config.fish → ~/.dotfiles/fish/config.fish
#  ~/.config/lvim/config.lua → ~/.dotfiles/lvim/config.lua
#  ~/.config/starship/starship.toml → ~/.dotfiles/starship/starship.toml
#  ~/.tmux.conf → ~/.dotfiles/tmux/.tmux.conf

# And add custom-scripts to your PATH in ~/.bashrc and ~/.zshrc

# Directory structure
dotfiles/
├── fish/config.fish
├── lvim/config.lua
├── starship/starship.toml
├── tmux/.tmux.conf
├── kitty/kitty.conf
├── custom-scripts/
└── install.sh

---

## Documentation

Detailed configuration documentation for each tool:

- **[Fish Shell](fish/README.md)** - Modern shell with intelligent features
- **[LunarVim](lvim/README.md)** - IDE layer for Neovim with extensive plugins
- **[Starship](starship/README.md)** - Customizable prompt with gradient design
- **[Tmux](tmux/README.md)** - Terminal multiplexer with rich plugin ecosystem
- **[Kitty](kitty/README.md)** - Fast GPU-based terminal emulator

```