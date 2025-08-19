# Set base dotfiles path
DOTFILES="$HOME/.dotfiles"

# Ensure base config directory exists
mkdir -p ~/.config

# Symlink dotfiles
ln -sf "$DOTFILES/fish/config.fish"         ~/.config/fish/config.fish
ln -sf "$DOTFILES/lvim/config.lua"          ~/.config/lvim/config.lua
ln -sf "$DOTFILES/starship/starship.toml"   ~/.config/starship.toml
ln -sf "$DOTFILES/tmux/.tmux.conf"          ~/.tmux.conf

echo "✅ Dotfiles linked!"

