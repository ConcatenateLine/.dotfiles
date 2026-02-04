# Set base dotfiles path
DOTFILES="$HOME/.dotfiles"

# Ensure base config directory exists
mkdir -p ~/.config

# Symlink dotfiles
ln -sf "$DOTFILES/fish/config.fish"         ~/.config/fish/config.fish
ln -sf "$DOTFILES/lvim/config.lua"          ~/.config/lvim/config.lua
ln -sf "$DOTFILES/starship/starship.toml"   ~/.config/starship.toml
ln -sf "$DOTFILES/tmux/.tmux.conf"          ~/.tmux.conf

# Add custom-scripts to PATH
echo 'export PATH="$HOME/.dotfiles/custom-scripts:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.dotfiles/custom-scripts:$PATH"' >> ~/.zshrc

echo "✅ Dotfiles linked!"
echo "✅ Custom-scripts added to PATH!"

