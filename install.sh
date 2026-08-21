#!/bin/bash
# ── Legacy install script ──────────────────────────────
# Most dotfiles are now managed declaratively via home-manager.
# Run: nix run home-manager/master -- switch --flake ~/.config/home-manager
#
# This script only handles:
#   1. custom-scripts PATH setup for bash/zsh
#   2. Fallback symlinks if home-manager is not available

set -e
DOTFILES="$HOME/.dotfiles"

mkdir -p ~/.config

# ── Home-manager path (preferred) ──────────────────────
HM_FLAKE="$DOTFILES/home-manager/flake.nix"
if [ -f "$HM_FLAKE" ]; then
  echo "✅ Home-manager flake detected at $DOTFILES/home-manager/"
  echo "   Run: nix run home-manager/master -- switch --flake $DOTFILES/home-manager -b backup"
else
  echo "⚠️  Home-manager flake not found. Using legacy symlinks..."

  ln -sf "$DOTFILES/fish/config.fish"                   ~/.config/fish/config.fish
  ln -sf "$DOTFILES/lvim/config.lua"                    ~/.config/lvim/config.lua
  ln -sf "$DOTFILES/starship/starship.toml"             ~/.config/starship.toml
  ln -sf "$DOTFILES/tmux/.tmux.conf"                    ~/.tmux.conf

  mkdir -p ~/.config/opencode
  rm -f ~/.config/opencode/*.json ~/.config/opencode/*.md
  for dir in agent skill themes tool; do
    [ -d ~/.config/opencode/$dir ] && rm -rf ~/.config/opencode/$dir
  done
  cp "$DOTFILES/opencode/opencode.json"             ~/.config/opencode/opencode.json
  cp "$DOTFILES/opencode/AGENTS.md"                 ~/.config/opencode/AGENTS.md
  cp "$DOTFILES/opencode/tui.json"                  ~/.config/opencode/tui.json
  cp "$DOTFILES/opencode/oh-my-opencode.json"       ~/.config/opencode/oh-my-opencode.json
  cp "$DOTFILES/opencode/oh-my-opencode-config.md"  ~/.config/opencode/oh-my-opencode-config.md
  cp "$DOTFILES/opencode/mcps-config.md"            ~/.config/opencode/mcps-config.md
  cp -r "$DOTFILES/opencode/agent"                 ~/.config/opencode/agent
  cp -r "$DOTFILES/opencode/skill"                 ~/.config/opencode/skill
  cp -r "$DOTFILES/opencode/themes"                ~/.config/opencode/themes
  cp -r "$DOTFILES/opencode/tool"                  ~/.config/opencode/tool

  mkdir -p ~/.config/devin
  ln -sf "$DOTFILES/devin/mcp_config.json"              ~/.config/devin/mcp_config.json
  ln -sf "$DOTFILES/devin/config.json"                  ~/.config/devin/config.json
  ln -sf "$DOTFILES/devin/global_rules.md"              ~/.config/devin/global_rules.md

  echo "✅ Legacy symlinks created!"
fi

# ── Custom scripts PATH ────────────────────────────────
grep -q 'dotfiles/custom-scripts' ~/.bashrc 2>/dev/null || echo 'export PATH="$HOME/.dotfiles/custom-scripts:$PATH"' >> ~/.bashrc
grep -q 'dotfiles/custom-scripts' ~/.zshrc 2>/dev/null || echo 'export PATH="$HOME/.dotfiles/custom-scripts:$PATH"' >> ~/.zshrc
grep -q 'dotfiles/custom-scripts' ~/.config/fish/config.fish 2>/dev/null || echo 'set -gx PATH $HOME/.dotfiles/custom-scripts $PATH' >> ~/.config/fish/config.fish

echo "✅ Custom-scripts added to PATH!"
