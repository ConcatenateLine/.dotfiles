# LunarVim Keymappings Table

Generated on: 2025-12-13  
Based on: `/home/ubuntuuser/.config/lvim/config.lua` and LunarVim defaults

## Table of Contents
1. [Window & Navigation](#window--navigation)
2. [File Management](#file-management)
3. [Git Operations](#git-operations)
4. [LSP & Code Intelligence](#lsp--code-intelligence)
5. [Search & Find](#search--find)
6. [Diagnostics & Troubleshooting](#diagnostics--troubleshooting)
7. [Text Editing & Manipulation](#text-editing--manipulation)
8. [Comments](#comments)
9. [AI & Code Assistance](#ai--code-assistance)
10. [Buffer Management](#buffer-management)
11. [Terminal & Shell](#terminal--shell)
12. [Replace & Refactor](#replace--refactor)
13. [Todo Management](#todo-management)
14. [Plugin Management](#plugin-management)
15. [LunarVim Core](#lunarvim-core)
16. [Visual Mode Specific](#visual-mode-specific)

---

## Window & Navigation

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<C-h>` | Normal | Move to left window | LunarVim default |
| `<C-j>` | Normal | Move to lower window | LunarVim default |
| `<C-k>` | Normal | Move to upper window | LunarVim default |
| `<C-l>` | Normal | Move to right window | LunarVim default |
| `<C-Up>` | Normal | Decrease window height | LunarVim default |
| `<C-Down>` | Normal | Increase window height | LunarVim default |
| `<C-Left>` | Normal | Decrease window width | LunarVim default |
| `<C-Right>` | Normal | Increase window width | LunarVim default |
| `<A-h>` | Insert | Navigate to left window | LunarVim default |
| `<A-j>` | Insert | Navigate to lower window | LunarVim default |
| `<A-k>` | Insert | Navigate to upper window | LunarVim default |
| `<A-l>` | Insert | Navigate to right window | LunarVim default |
| `<C-h>` | Terminal | Navigate to left window | LunarVim default |
| `<C-j>` | Terminal | Navigate to lower window | LunarVim default |
| `<C-k>` | Terminal | Navigate to upper window | LunarVim default |
| `<C-l>` | Terminal | Navigate to right window | LunarVim default |

---

## File Management

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>f` | Normal | Find files (Telescope) | LunarVim default |
| `<Space>e` | Normal | Toggle file explorer (NvimTree) | LunarVim default |
| `-` | Normal | Open parent directory (Oil) | Custom (oil.nvim) |
| `<Space>-` | Normal | Open parent directory in floating window (Oil) | Custom (oil.nvim) |
| `<M-h>` | Normal (Oil) | Open file in split (Oil) | Custom (oil.nvim) |
| `<Space>sr` | Normal | Open recent files | LunarVim default |

---

## Git Operations

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>lg` | Normal | Open LazyGit | Custom (lazygit.nvim) |
| `<Space>g` | Normal | Git menu | LunarVim default |
| `<Space>gg` | Normal | LazyGit toggle | LunarVim default |
| `<Space>gj` | Normal | Next git hunk | LunarVim default |
| `<Space>gk` | Normal | Previous git hunk | LunarVim default |
| `<Space>gl` | Normal | Git blame line | LunarVim default |
| `<Space>gL` | Normal | Git blame line (full) | LunarVim default |
| `<Space>gp` | Normal | Preview git hunk | LunarVim default |
| `<Space>gr` | Normal | Reset git hunk | LunarVim default |
| `<Space>gR` | Normal | Reset git buffer | LunarVim default |
| `<Space>gs` | Normal | Stage git hunk | LunarVim default |
| `<Space>gu` | Normal | Undo stage git hunk | LunarVim default |
| `<Space>go` | Normal | Open changed file (Telescope) | LunarVim default |
| `<Space>gb` | Normal | Checkout git branch (Telescope) | LunarVim default |
| `<Space>gc` | Normal | Checkout git commit (Telescope) | LunarVim default |
| `<Space>gC` | Normal | Checkout commit for current file (Telescope) | LunarVim default |
| `<Space>gd` | Normal | Git diff | LunarVim default |
| `]c` | Normal | Next git hunk | LunarVim default |
| `[c` | Normal | Previous git hunk | LunarVim default |
| `<Space>gb` | Visual | Reset hunk | LunarVim default |
| `<Space>gs` | Visual | Stage hunk | LunarVim default |

---

## LSP & Code Intelligence

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `K` | Normal | Hover information | LunarVim default |
| `gd` | Normal | Go to definition | LunarVim default |
| `gD` | Normal | Go to declaration | LunarVim default |
| `gr` | Normal | Go to references | LunarVim default |
| `gI` | Normal | Go to implementation | LunarVim default |
| `gs` | Normal | Show signature help | LunarVim default |
| `gl` | Normal | Show line diagnostics | LunarVim default |
| `<Space>l` | Normal | LSP menu | LunarVim default |
| `<Space>la` | Normal | Code action | LunarVim default |
| `<Space>ld` | Normal | Buffer diagnostics (Telescope) | LunarVim default |
| `<Space>lw` | Normal | Workspace diagnostics (Telescope) | LunarVim default |
| `<Space>lf` | Normal | Format code | LunarVim default |
| `<Space>li` | Normal | LSP info | LunarVim default |
| `<Space>lI` | Normal | Mason info | LunarVim default |
| `<Space>lj` | Normal | Next diagnostic | LunarVim default |
| `<Space>lk` | Normal | Previous diagnostic | LunarVim default |
| `<Space>ll` | Normal | CodeLens action | LunarVim default |
| `<Space>lq` | Normal | Quickfix diagnostics | LunarVim default |
| `<Space>lr` | Normal | Rename symbol | LunarVim default |
| `<Space>ls` | Normal | Document symbols (Telescope) | LunarVim default |
| `<Space>lS` | Normal | Workspace symbols (Telescope) | LunarVim default |
| `<Space>le` | Normal | Telescope quickfix | LunarVim default |
| `<Space>la` | Visual | Code action | LunarVim default |

---

## Search & Find

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>s` | Normal | Search menu | LunarVim default |
| `<Space>sb` | Normal | Checkout git branch (Telescope) | LunarVim default |
| `<Space>sc` | Normal | Colorscheme (Telescope) | LunarVim default |
| `<Space>sf` | Normal | Find files (Telescope) | LunarVim default |
| `<Space>sh` | Normal | Find help (Telescope) | LunarVim default |
| `<Space>sH` | Normal | Find highlight groups (Telescope) | LunarVim default |
| `<Space>sM` | Normal | Man pages (Telescope) | LunarVim default |
| `<Space>sr` | Normal | Open recent files (Telescope) | LunarVim default |
| `<Space>sR` | Normal | Registers (Telescope) | LunarVim default |
| `<Space>st` | Normal | Live grep (Telescope) | LunarVim default |
| `<Space>sk` | Normal | Keymaps (Telescope) | LunarVim default |
| `<Space>sC` | Normal | Commands (Telescope) | LunarVim default |
| `<Space>sl` | Normal | Resume last search (Telescope) | LunarVim default |
| `<Space>sp` | Normal | Colorscheme with preview (Telescope) | LunarVim default |
| `<Space>sh` | Normal | Search through `:help` | LunarVim default |

---

## Diagnostics & Troubleshooting

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>t` | Normal | Diagnostics menu (Trouble) | Custom |
| `<Space>tt` | Normal | Toggle diagnostics (Trouble) | Custom |
| `<Space>tb` | Normal | Buffer diagnostics (Trouble) | Custom |
| `<Space>ts` | Normal | Symbols (Trouble) | Custom |
| `<Space>tr` | Normal | LSP definitions/references (Trouble) | Custom |
| `<Space>tl` | Normal | Location list (Trouble) | Custom |
| `<Space>tq` | Normal | Quickfix list (Trouble) | Custom |
| `[d` | Normal | Previous diagnostic | LunarVim default |
| `]d` | Normal | Next diagnostic | LunarVim default |

---

## Text Editing & Manipulation

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<A-j>` | Normal | Move line down | LunarVim default |
| `<A-k>` | Normal | Move line up | LunarVim default |
| `<A-j>` | Insert | Move line down | LunarVim default |
| `<A-k>` | Insert | Move line up | LunarVim default |
| `<A-j>` | Visual block | Move selection down | LunarVim default |
| `<A-k>` | Visual block | Move selection up | LunarVim default |
| `<` | Visual | Indent left (stay in visual) | LunarVim default |
| `>` | Visual | Indent right (stay in visual) | LunarVim default |
| `s` | Normal | Hop to 2 characters | Custom (hop.nvim) |
| `S` | Normal | Hop to word | Custom (hop.nvim) |
| `+` | Normal | Increment number | Custom (opencode.nvim) |
| `-` | Normal | Decrement number | Custom (opencode.nvim) |

---

## Comments

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>/` | Normal | Toggle comment line | LunarVim default |
| `<Space>/` | Visual | Toggle comment linewise | LunarVim default |
| `gc` | Operator | Comment operator with motion | LunarVim default |
| `gcc` | Normal | Toggle comment line | LunarVim default |
| `gbc` | Normal | Toggle comment block | LunarVim default |

---

## AI & Code Assistance

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<M-c>` | Insert | Accept Codeium suggestion | Custom (codeium.vim) |
| `<M-x>` | Insert | Clear Codeium suggestion | Custom (codeium.vim) |
| `<C-a>` | Normal/Visual | Ask OpenCode | Custom (opencode.nvim) |
| `<C-x>` | Normal/Visual | Execute OpenCode action | Custom (opencode.nvim) |
| `ga` | Normal/Visual | Add to OpenCode | Custom (opencode.nvim) |
| `<C-.>` | Normal/Terminal | Toggle OpenCode | Custom (opencode.nvim) |
| `<S-C-u>` | Normal | OpenCode half page up | Custom (opencode.nvim) |
| `<S-C-d>` | Normal | OpenCode half page down | Custom (opencode.nvim) |

---

## Buffer Management

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>b` | Normal | Buffer menu | LunarVim default |
| `<Space>bj` | Normal | Jump to buffer (BufferLine) | LunarVim default |
| `<Space>bf` | Normal | Find buffer (Telescope) | LunarVim default |
| `<Space>bb` | Normal | Previous buffer | LunarVim default |
| `<Space>bn` | Normal | Next buffer | LunarVim default |
| `<Space>bW` | Normal | Save without formatting | LunarVim default |
| `<Space>be` | Normal | Pick buffer to close | LunarVim default |
| `<Space>bh` | Normal | Close all buffers to left | LunarVim default |
| `<Space>bl` | Normal | Close all buffers to right | LunarVim default |
| `<Space>bD` | Normal | Sort buffers by directory | LunarVim default |
| `<Space>bL` | Normal | Sort buffers by extension | LunarVim default |
| `<Space>c` | Normal | Close buffer | LunarVim default |
| `<S-h>` | Normal | Previous buffer | LunarVim default |
| `<S-l>` | Normal | Next buffer | LunarVim default |

---

## Terminal & Shell

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>\`` | Normal | Toggle terminal | LunarVim default |
| `<C-/>` | Normal | Open floating terminal | LunarVim default |
| `<C-t>` | Terminal | Terminal mode escape | LunarVim default |

---

## Replace & Refactor

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>r` | Normal | Replace & Todo menu | Custom |
| `<Space>rn` | Normal | Toggle Muren UI | Custom (muren.nvim) |
| `<Space>rf` | Normal | Open fresh Muren UI | Custom (muren.nvim) |

---

## Todo Management

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>rq` | Normal | Quickfix todo comments | Custom (todo-comments.nvim) |
| `<Space>rl` | Normal | Telescope todo comments | Custom (todo-comments.nvim) |
| `<Space>rt` | Normal | Trouble todo comments | Custom (todo-comments.nvim) |
| `<Space>rc` | Normal | Location list todo comments | Custom (todo-comments.nvim) |
| `<Space>rz` | Normal | FzfLua todo comments | Custom (todo-comments.nvim) |

---

## Plugin Management

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>p` | Normal | Plugin menu | LunarVim default |
| `<Space>pi` | Normal | Install plugins (Lazy) | LunarVim default |
| `<Space>ps` | Normal | Sync plugins (Lazy) | LunarVim default |
| `<Space>pS` | Normal | Plugin status (Lazy) | LunarVim default |
| `<Space>pc` | Normal | Clean plugins (Lazy) | LunarVim default |
| `<Space>pu` | Normal | Update plugins (Lazy) | LunarVim default |
| `<Space>pp` | Normal | Profile plugins (Lazy) | LunarVim default |
| `<Space>pl` | Normal | Plugin log (Lazy) | LunarVim default |
| `<Space>pd` | Normal | Debug plugins (Lazy) | LunarVim default |

---

## LunarVim Core

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>L` | Normal | LunarVim menu | LunarVim default |
| `<Space>Lc` | Normal | Edit config.lua | LunarVim default |
| `<Space>Ld` | Normal | View LunarVim docs | LunarVim default |
| `<Space>Lf` | Normal | Find LunarVim files | LunarVim default |
| `<Space>Lg` | Normal | Grep LunarVim files | LunarVim default |
| `<Space>Lk` | Normal | View LunarVim keymappings | LunarVim default |
| `<Space>Li` | Normal | Toggle LunarVim info | LunarVim default |
| `<Space>LI` | Normal | View LunarVim changelog | LunarVim default |
| `<Space>Lr` | Normal | Reload LunarVim config | LunarVim default |
| `<Space>Lu` | Normal | Update LunarVim | LunarVim default |
| `<Space>Lld` | Normal | View default log | LunarVim default |
| `<Space>LlD` | Normal | Open default logfile | LunarVim default |
| `<Space>Lll` | Normal | View LSP log | LunarVim default |
| `<Space>LlL` | Normal | Open LSP logfile | LunarVim default |
| `<Space>Lln` | Normal | View Neovim log | LunarVim default |
| `<Space>LlN` | Normal | Open Neovim logfile | LunarVim default |

---

## Visual Mode Specific

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>/` | Visual | Toggle comment linewise | LunarVim default |
| `<Space>l` | Visual | LSP menu | LunarVim default |
| `<Space>la` | Visual | Code action | LunarVim default |
| `<Space>g` | Visual | Git menu | LunarVim default |
| `<Space>gb` | Visual | Reset hunk | LunarVim default |
| `<Space>gs` | Visual | Stage hunk | LunarVim default |
| `<C-a>` | Visual | Ask OpenCode | Custom (opencode.nvim) |
| `<C-x>` | Visual | Execute OpenCode action | Custom (opencode.nvim) |
| `ga` | Visual | Add to OpenCode | Custom (opencode.nvim) |

---

## QuickFix Navigation

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `]q` | Normal | Next QuickFix item | LunarVim default |
| `[q` | Normal | Previous QuickFix item | LunarVim default |
| `<C-q>` | Normal | Toggle QuickFix window | LunarVim default |

---

## Command Mode

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<C-j>` | Command | Next completion item | LunarVim default |
| `<C-k>` | Command | Previous completion item | LunarVim default |

---

## Debug (DAP)

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>d` | Normal | Debug menu | LunarVim default |
| `<Space>dt` | Normal | Toggle breakpoint | LunarVim default |
| `<Space>db` | Normal | Step back | LunarVim default |
| `<Space>dc` | Normal | Continue | LunarVim default |
| `<Space>dC` | Normal | Run to cursor | LunarVim default |
| `<Space>dd` | Normal | Disconnect | LunarVim default |
| `<Space>dg` | Normal | Get session | LunarVim default |
| `<Space>di` | Normal | Step into | LunarVim default |
| `<Space>do` | Normal | Step over | LunarVim default |
| `<Space>du` | Normal | Step out | LunarVim default |
| `<Space>dp` | Normal | Pause | LunarVim default |
| `<Space>dr` | Normal | Toggle REPL | LunarVim default |
| `<Space>ds` | Normal | Start debugging | LunarVim default |
| `<Space>dq` | Normal | Quit debugging | LunarVim default |
| `<Space>dU` | Normal | Toggle UI | LunarVim default |

---

## Treesitter

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>T` | Normal | Treesitter menu | LunarVim default |
| `<Space>Ti` | Normal | Treesitter info | LunarVim default |

---

## Core Actions

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Space>;` | Normal | Dashboard (Alpha) | LunarVim default |
| `<Space>w` | Normal | Save file | LunarVim default |
| `<Space>q` | Normal | Quit | LunarVim default |
| `<Space>h` | Normal | No highlight | LunarVim default |

---

## Summary Statistics

- **Total Keymappings**: 180+
- **Custom Mappings**: 25+ (from user config)
- **Default LunarVim**: 150+
- **Major Categories**: 18
- **Modes Covered**: Normal, Insert, Visual, Visual Block, Terminal, Command

## Conflicts & Overrides

1. **Oil.nvim**: Disables `<C-h/j/k/l>` in oil buffers
2. **Hop.nvim**: Overrides `s` and `S` keys
3. **OpenCode**: Overrides `+` and `-` increment/decrement
4. **Custom Mappings**: `<Space>r` and `<Space>t` completely replace defaults

## Notes

- All `<Space>` leader mappings are handled by which-key
- Some mappings are context-dependent (e.g., oil buffers, git files)
- Plugin-specific mappings may only work when plugins are active
- Visual mode mappings often mirror normal mode with visual-specific actions