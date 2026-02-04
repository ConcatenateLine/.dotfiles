# LunarVim Configuration

## Overview
LunarVim is an IDE layer for Neovim that provides a full-featured development environment with excellent defaults and extensive customization options.

## Configuration Details

### Plugin Ecosystem
The configuration includes a rich set of plugins for enhanced productivity:

#### Visual & UI Enhancements
- **smear-cursor.nvim**: Smooth cursor animations between buffers and lines with extensive customization
- **aurora**: Beautiful color scheme with transparency and italic support
- **github-theme**: GitHub's official color schemes
- **evergarden**: Nature-inspired color theme (fall variant, green accent)
- **nvim-ufo**: Advanced folding with treesitter and indent providers

#### Navigation & Search
- **hop.nvim**: Jump to any character in the buffer (key: `s` for char2, `S` for word)
- **fzf-lua**: High-performance fuzzy finder with icon support
- **telescope-fzy-native**: Native fzy algorithm for better performance

#### File Management
- **oil.nvim**: File explorer with vim-like navigation (key: `-` to open parent)
- Shows hidden files by default, excludes build artifacts

#### Development Tools
- **trouble.nvim**: Beautiful diagnostics display with auto-preview disabled
- **todo-comments.nvim**: Highlight and navigate TODO comments
- **lazygit.nvim**: Git interface integration (leader+lg)
- **muren.nvim**: Advanced search and replace (leader+r mappings)
- **codeium.vim**: AI-powered code completion (Alt+c to accept, Alt+x to clear)
- **opencode.nvim**: AI assistant integration with enhanced context and custom prompts
- **neotest**: Testing framework with Vitest and Playwright adapters
- **glow.nvim**: Markdown preview with Glow
- **nvim-treesitter-angular**: Angular language support

#### Utilities
- **vim-sanegx**: Open URLs in browser
- **snacks.nvim**: Required for opencode functionality

### Custom Keybindings

#### Which Key Mappings
- **leader+r**: Replace & Todo operations
  - `n`: Toggle muren UI
  - `f`: Open fresh muren UI
  - `q/l/t/c/z`: Todo comment navigation
- **leader+t**: Diagnostics with Trouble
  - `t`: All diagnostics
  - `b`: Buffer diagnostics
  - `s`: Symbols
  - `r`: LSP definitions/references

#### Navigation
- `s`: Hop to character (2-char mode)
- `S`: Hop to word
- `-`: Open parent directory with Oil
- `<space>-`: Toggle Oil floating window

#### AI & Completion
- `<M-c>`: Accept Codeium suggestion
- `<M-x>`: Clear Codeium suggestion
- `<M-f>`: Ask opencode (enhanced from Ctrl+a)
- `<M-g>`: Execute opencode action (enhanced from Ctrl+x)
- `ga`: Add to opencode context
- `<M-q>`: Toggle opencode
- `<M-up>/<M-down>`: Navigate opencode session (half page)
- `<M-left>/<M-right>`: Navigate opencode session (full page)
- `<M-k>/<M-j>`: Jump to first/last opencode message

### Testing Framework
- **neotest**: Integrated testing with support for:
  - Vitest for unit testing
  - Playwright for end-to-end testing
  - Automatic test discovery excluding node_modules
  - Dynamic test discovery for Playwright

### LSP Configuration
- **Angular Language Server**: Pre-configured for Angular development
- **Markdownlint**: Formatter for Markdown files

### File Management
- **NvimTree**: Auto-close when opening files
- **Oil**: File explorer with hidden files and build artifact filtering
### Status Line Configuration
Custom lualine setup with:
- Global status bar with auto theme
- Custom rounded separators
- Codeium status indicator with "IA:" icon
- Opencode status integration
- Progress, location, file format, encoding, and filetype info
- Diff and diagnostics in center section

### Autocommands
- **BufRead**: Close unnamed buffers when opening files
- **BufDelete**: Return to Alpha dashboard when last buffer closes
- **VimEnter**: Auto-launch Alpha dashboard when no file specified

### Visual Settings
- Transparent window enabled
- Primary colorscheme: evergarden (fall variant)
- Custom highlight overrides for numbers

## File Location
`~/.config/lvim/config.lua` → `~/.dotfiles/lvim/config.lua`