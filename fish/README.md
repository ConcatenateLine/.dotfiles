# Fish Shell Configuration

## Overview
Fish is a modern, user-friendly command line shell with intelligent features like autosuggestions and syntax highlighting.

## Configuration Details

### PATH Setup
- Local binaries: `~/.local/bin`
- Neovim: `/opt/nvim-linux-x86_64/bin`
- Go: `/usr/local/go/bin` and `~/go/bin`
- Node.js: `/home/ubuntuuser/.nvm/versions/node/v22.17.0/bin`
- Bun: `$HOME/.bun/bin`
- Opencode: `/home/ubuntuuser/.opencode/bin`

### Development Tools Integration
- **NVM**: Node Version Manager with bass integration for Fish
- **Bun**: JavaScript runtime and package manager with PATH configuration
- **Starship**: Custom prompt initialized
- **fzf**: Fuzzy finder with multiple integration methods
- **mise**: Development environment manager
- **lvim**: Virtual environment activation for LunarVim

### Special Configurations
- **WSL**: `DONT_PROMPT_WSL_INSTALL=1` to prevent WSL install prompts
- **Kiro**: Terminal integration support
- **Interactive Mode**: Commands only run in interactive sessions

## Key Features
- Intelligent autosuggestions
- Syntax highlighting
- Man page completions
- Web-based configuration
- Universal variables
- Plugin support

## File Location
`~/.config/fish/config.fish` → `~/.dotfiles/fish/config.fish`