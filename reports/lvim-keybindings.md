# LunarVim Keybindings Analysis Report

Generated on: 2025-12-13  
Based on actual configuration files in your system

## Configuration Files Analyzed
- **User Config**: `/home/ubuntuuser/.config/lvim/config.lua`
- **LunarVim Defaults**: `/home/ubuntuuser/.local/share/lunarvim/lvim/lua/lvim/keymappings.lua`
- **Which-Key Defaults**: `/home/ubuntuuser/.local/share/lunarvim/lvim/lua/lvim/core/which-key.lua`

---

## 1. Default LunarVim Keybindings

### Core Navigation (from keymappings.lua)
| Mode | Key | Action |
|------|-----|--------|
| Normal | `<C-h>` | Move to left window |
| Normal | `<C-j>` | Move to lower window |
| Normal | `<C-k>` | Move to upper window |
| Normal | `<C-l>` | Move to right window |
| Normal | `<C-Up>` | Decrease window height |
| Normal | `<C-Down>` | Increase window height |
| Normal | `<C-Left>` | Decrease window width |
| Normal | `<C-Right>` | Increase window width |
| Normal | `<A-j>` | Move line down |
| Normal | `<A-k>` | Move line up |
| Insert | `<A-j>` | Move line down (insert mode) |
| Insert | `<A-k>` | Move line up (insert mode) |
| Terminal | `<C-h/j/k/l>` | Navigate from terminal |

### Default Which-Key Mappings (from which-key.lua)
| Leader Key | Action |
|------------|--------|
| `<Space>;` | Dashboard (Alpha) |
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `<Space>/` | Toggle comment line |
| `<Space>c` | Close buffer |
| `<Space>f` | Find files |
| `<Space>h` | No highlight |
| `<Space>e` | Toggle file explorer |

---

## 2. Your Custom Modifications

### Custom Plugin Keybindings

#### hop.nvim (Lines 33-40)
```lua
vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
```
**Impact**: Overrides default `s` key (substitute command)

#### oil.nvim (Lines 79-103)
```lua
keymaps = {
  ["<C-h>"] = false,    -- DISABLED default window navigation
  ["<C-l>"] = false,    -- DISABLED default window navigation  
  ["<C-k>"] = false,    -- DISABLED default window navigation
  ["<C-j>"] = false,    -- DISABLED default window navigation
  ["<M-h>"] = "actions.select_split",
}
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<space>-", require("oil").toggle_float)
```
**Impact**: **MAJOR CONFLICT** - Disables core window navigation in oil buffers

#### codeium.vim (Lines 157-160)
```lua
vim.keymap.set('i', '<M-c>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
vim.keymap.set('i', '<M-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
```
**Impact**: New insert mode mappings

#### lazygit.nvim (Lines 178-180)
```lua
keys = {
  { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
}
```
**Impact**: New leader mapping

#### opencode.nvim (Lines 222-234)
```lua
vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end)
vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end)
vim.keymap.set({ "n", "x" }, "ga", function() require("opencode").prompt("@this") end)
vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end)
vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end)
vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end)
vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })
```
**Impact**: **MAJOR CONFLICT** - Overrides increment/decrement functionality

### Custom Which-Key Mappings

#### Replace & Todo (Lines 239-249)
```lua
lvim.builtin.which_key.mappings["r"] = {
  name = "Replace&Todo",
  n = { "<cmd>lua require('muren.api').toggle_ui()<cr>", "Toggle muren UI" },
  f = { "<cmd>lua require('muren.api').open_fresh_ui()<cr>", "Open fresh muren UI" },
  q = { "<cmd>:TodoQuickFix<cr>", "Quickfix todo comments" },
  l = { "<cmd>:TodoTelescope<cr>", "Telescope todo comments" },
  t = { "<cmd>:TodoTrouble<cr>", "Trouble todo comments" },
  c = { "<cmd>:TodoLocList<cr>", "Location list todo comments" },
  z = { "<cmd>:TodoFzfLua<cr>", "FzfLua todo comments" },
}
```
**Impact**: Overrides default `<Space>r` (likely restore/replace)

#### Diagnostics (Lines 251-259)
```lua
lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (Trouble)" },
  b = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics (Trouble)" },
  s = { "<cmd>Trouble symbols toggle focus=true<cr>", "Symbols (Trouble)" },
  r = { "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", "LSP Definitions / references/ ... (Trouble)" },
  l = { "<cmd>Trouble loclist toggle<cr>", "Location list (Trouble)" },
  q = { "<cmd>Trouble qflist toggle<cr>", "Quickfix List (Trouble)" },
}
```
**Impact**: Overrides default `<Space>t` (likely treesitter/theme)

---

## 3. Conflicts and Issues Identified

### 🚨 Critical Conflicts

#### 1. Window Navigation in Oil
- **Problem**: oil.nvim disables `<C-h/j/k/l>` in oil buffers
- **Impact**: Cannot navigate windows from oil file explorer
- **Default Behavior**: These keys should navigate between windows
- **Current Behavior**: Disabled, only `<M-h>` works for split opening
- **Status**: This is intentional enhancement, not a conflict, use `<C-w> h/j/k/l`

#### 2. Increment/Decrement Override
- **Problem**: opencode.nvim overrides `+` and `-` keys
- **Line 233-234**: 
  ```lua
  vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
  vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })
  ```
- **Impact**: `-` key now calls increment instead of Oil/decrement
- **Conflict**: Oil also wants `-` for "Open parent directory"
- **Status**:

#### 3. Hop Navigation Override
- **Problem**: `s` key mapped to HopChar2
- **Default Behavior**: `s` is substitute command
- **Impact**: Lost native substitute functionality

#### 4. Comment Operator Override
- **Problem**: `gc` operator is defined in which-key config
- **Default Behavior**: `gc` is not a standard Vim operator
- **Impact**: Enables comment.nvim functionality with `gc` motions (e.g., `gcip` to comment paragraph)
- **Status**: This is intentional enhancement, not a conflict

### ⚠️ Potential Issues

#### 1. Leader Key Consistency
- Your config uses `<leader>lg` for LazyGit
- Default has `<leader>gg` for LazyGit
- Both work, but inconsistent

#### 2. Git Mappings in Visual Mode
- Default which-key defines `gb` and `gc` in visual mode under `g` group
- `gb` = reset hunk, `gc` = stage hunk (visual mode only)
- These work alongside normal mode git mappings

#### 2. Missing Default Mappings
- `<Space>r` - Default likely had restore/replace functionality
- `<Space>t` - Default had treesitter commands
- These are completely replaced by your custom setups

---

## 4. Working Keybindings Summary

### ✅ Working Normally
- All core navigation (`<C-h/j/k/l>`) outside oil buffers
- Default which-key mappings (`<Space>f`, `<Space>e`, `<Space>w`, etc.)
- LSP mappings (`<Space>l` group)
- Git mappings (`<Space>g` group)

### ✅ Custom Working
- `<Space>r` - Replace & Todo features
- `<Space>t` - Trouble diagnostics
- `<Space>lg` - LazyGit
- `s`/`S` - Hop navigation
- `<M-c>`/`<M-x>` - Codeium in insert mode
- `<C-a>`/`<C-x>`/`ga` - OpenCode functionality
- `gc` + motion - Comment operator (e.g., `gcip` comments paragraph)
- Visual `gb`/`gc` - Git reset/stage hunk in visual mode

### ⚠️ Partially Working
- `-` - Opens Oil (works) but increment functionality redirected
- `<Space>-` - Oil float (works)

### ❌ Broken/Conflicted
- Window navigation from within oil buffers
- Native `s` substitute command
- Default `<Space>r` functionality (unknown what it was)
- Default `<Space>t` functionality (treesitter)

---

## 5. Recommendations

### High Priority Fixes
1. [x] **Fix Oil Window Navigation**: Add alternative navigation in oil
2. [x] **Resolve Increment/Decrement Conflict**: Choose different keys for OpenCode
3. **Restore Substitute Command**: Map Hop to different keys

### Medium Priority
1. **Document Custom Mappings**: Create personal documentation
2. **Consider Consistency**: Align LazyGit with default `<Space>gg`

### Low Priority  
1. **Review Lost Defaults**: Determine if you need replaced functionality

---

## 6. Quick Reference for Your Current Setup

### Daily Use Keybindings
- **Files**: `<Space>f` (find), `<Space>e` (explorer), `-` (oil)
- **Navigation**: `<C-h/j/k/l>` (windows), `s`/`S` (hop)
- **Git**: `<Space>lg` (lazygit), `<Space>g` (git operations)
- **Diagnostics**: `<Space>t` (trouble)
- **Replace/Todo**: `<Space>r` (muren + todos)
- **AI**: `<M-c>` (accept codeium), `<C-a>` (ask opencode)
- **Comments**: `gc` + motion (comment operator), visual `gb`/`gc` (git hunks)

### Conflicts to Remember
- Don't use `s` for substitute, use `:s` instead
- Window navigation doesn't work inside oil
- `-` opens oil, not decrement
- `gc` is comment operator, not a standard Vim command
- Visual `gb`/`gc` are git commands, not standard
