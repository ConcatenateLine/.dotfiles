# Tmux Configuration

## Overview
Tmux is a terminal multiplexer that allows multiple terminal sessions within a single window. This configuration provides a feature-rich development environment with extensive plugin support.

## Configuration Details

### Key Bindings

#### Prefix & Navigation
- **Prefix**: `Ctrl-a` (changed from default `Ctrl-b`)
- **Pane Navigation**: Vim-style (`h`, `j`, `k`, `l`)
- **Pane Resizing**: `Ctrl-a` + `Shift` + `h/j/k/l` (5-step increments)
- **Window Splitting**: `|` for horizontal, `-` for vertical
- **Config Reload**: `Ctrl-a` + `r`

#### Plugin-Specific Bindings
- **SessionX**: `Ctrl-a` + `o` for session management
- **Floax**: `Ctrl-a` + `g` for floating windows

### Plugin Ecosystem (TPM)

#### Core Plugins
- **tmux-sensible**: Sensible defaults
- **tmux-resurrect**: Save/restore sessions
- **tmux-continuum**: Automatic session saving
- **tmux-yank**: Better copying integration

#### Enhancement Plugins
- **tmux-thumbs**: Vim-like visual selection
- **tmux-fzf**: Fuzzy finder integration
- **tmux-fzf-url**: URL fuzzy finding
- **catppuccin-tmux**: Beautiful color scheme
- **tmux-sessionx**: Advanced session management
- **tmux-floax**: Floating window manager

### Session Management
- **Auto-restore**: Continuum automatically restores sessions on tmux start
- **Neovim Strategy**: Preserves Neovim sessions across restarts
- **SessionX Features**:
  - Zoxide integration for directory navigation
  - Custom paths support (includes ~/.dotfiles)
  - 85% height, 75% width window size
  - Ctrl-y for new window creation

### Visual Configuration

#### Catppuccin Theme
- **Window Separators**: Powerline-style with  and 
- **Window Numbers**: Right-aligned with zoom indicator
- **Status Bar**: Session info on left, directory and time on right
- **Directory Display**: Shows current pane path
- **Calendar Integration**: Custom script for meeting display

#### Status Bar
- **Left**: Session name with color coding
- **Right**: Username, prefix highlight, date/time
- **Colors**: Dark background (#234) with orange accents (#136)

### Advanced Features

#### Floax Configuration
- **Size**: 80% width and height
- **Colors**: Magenta border, blue text
- **Path Changing**: Enabled for dynamic navigation
- **Binding**: `g` key for quick access

#### Copy Mode
- **Vi Keys**: Vim-style navigation in copy mode
- **Enhanced Yanking**: Better clipboard integration

## Installation
1. Install TPM (Tmux Plugin Manager):
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```
2. Install plugins: `Ctrl-a` + `I`
3. Update plugins: `Ctrl-a` + `U`

## File Location
`~/.tmux.conf` → `~/.dotfiles/tmux/.tmux.conf`