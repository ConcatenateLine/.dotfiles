#!/bin/bash
# Set base dotfiles path
DOTFILES="$HOME/.dotfiles"

# Ensure base config directory exists
mkdir -p ~/.config

# Symlink dotfiles — individual config files
ln -sf "$DOTFILES/fish/config.fish"                      ~/.config/fish/config.fish
ln -sf "$DOTFILES/lvim/config.lua"                       ~/.config/lvim/config.lua
ln -sf "$DOTFILES/starship/starship.toml"                ~/.config/starship.toml
ln -sf "$DOTFILES/tmux/.tmux.conf"                       ~/.tmux.conf

# Ensure opencode parent dir exists
mkdir -p ~/.config/opencode

# Remove existing real dirs before symlinking (ln -sf won't replace dirs)
for dir in agent skill themes tool; do
  [ -d ~/.config/opencode/$dir ] && [ ! -L ~/.config/opencode/$dir ] && rm -rf ~/.config/opencode/$dir
done

# Opencode — individual config files
ln -sf "$DOTFILES/opencode/opencode.json"                ~/.config/opencode/opencode.json
ln -sf "$DOTFILES/opencode/AGENTS.md"                    ~/.config/opencode/AGENTS.md
ln -sf "$DOTFILES/opencode/tui.json"                     ~/.config/opencode/tui.json
ln -sf "$DOTFILES/opencode/oh-my-opencode.json"          ~/.config/opencode/oh-my-opencode.json
ln -sf "$DOTFILES/opencode/oh-my-opencode-config.md"     ~/.config/opencode/oh-my-opencode-config.md
ln -sf "$DOTFILES/opencode/mcps-config.md"               ~/.config/opencode/mcps-config.md

# Opencode — config directories
ln -sf "$DOTFILES/opencode/agent"                        ~/.config/opencode/agent
ln -sf "$DOTFILES/opencode/skill"                        ~/.config/opencode/skill
ln -sf "$DOTFILES/opencode/themes"                       ~/.config/opencode/themes
ln -sf "$DOTFILES/opencode/tool"                         ~/.config/opencode/tool

# Devin — config files
mkdir -p ~/.config/devin
ln -sf "$DOTFILES/devin/mcp_config.json"                 ~/.config/devin/mcp_config.json
ln -sf "$DOTFILES/devin/config.json"                     ~/.config/devin/config.json
ln -sf "$DOTFILES/devin/global_rules.md"                 ~/.config/devin/global_rules.md

# Add custom-scripts to PATH (idempotent)
grep -q 'dotfiles/custom-scripts' ~/.bashrc 2>/dev/null || echo 'export PATH="$HOME/.dotfiles/custom-scripts:$PATH"' >> ~/.bashrc
grep -q 'dotfiles/custom-scripts' ~/.zshrc 2>/dev/null || echo 'export PATH="$HOME/.dotfiles/custom-scripts:$PATH"' >> ~/.zshrc

echo "✅ Dotfiles linked!"
echo "✅ Custom-scripts added to PATH!"
