# 🧼 Minimal Dotfiles

Minimal dotfiles setup for tmux, zsh, kitty, and Neovim.

This setup is managed using [GNU Stow](https://www.gnu.org/software/stow/), which simplifies symlinking dotfiles into your `$HOME` directory.

---

## Install

```bash
git clone https://github.com/concatenateline/dotfiles ~/.dotfiles
cd ~/.dotfiles

# Use stow to symlink each module
stow shell
stow tmux
stow kitty
stow nvim

# This will create symlinks like:
#  ~/.zshrc → ~/.dotfiles/shell/.zshrc
#  ~/.tmux.conf → ~/.dotfiles/tmux/.tmux.conf
#  ~/.config/kitty/kitty.conf → ~/.dotfiles/kitty/kitty.conf
#  ~/.config/nvim/init.vim → ~/.dotfiles/nvim/init.vim

# Removing a config
stow -D kitty

# Directory structure
dotfiles/
├── shell/.zshrc
├── tmux/.tmux.conf
├── kitty/kitty.conf
├── nvim/init.vim
└── install.sh

# You can run ./install.sh to apply everything at once:
chmod +x install.sh
./install.sh

