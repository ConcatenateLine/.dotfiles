local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder and wezterm.config_builder() or {}

-- ============================================================================
-- WINDOW APPEARANCE
-- ============================================================================
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = true
config.tab_max_width = 32
config.tab_bar_at_bottom = false
config.win32_system_backdrop = 'Acrylic'  -- Requires Windows 11
config.window_background_opacity = 0.85

-- ============================================================================
-- CURSOR
-- ============================================================================
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 700
config.cursor_thickness = '2px'

-- ============================================================================
-- SCROLLBACK
-- ============================================================================
config.scrollback_lines = 10000

-- ============================================================================
-- ADDITIONAL SETTINGS
-- ============================================================================
config.enable_scroll_bar = true
config.adjust_window_size_when_changing_font_size = false
config.audible_bell = "Disabled"
config.check_for_updates = false

-- ============================================================================
-- EVERGARDEN WINTER COLOR SCHEME
-- Inspired by: https://github.com/everviolet/nvim
-- A cozy winter theme inspired by everforest and nord
-- ============================================================================
config.color_scheme_dirs = { '.' }
config.colors = {
  -- Foreground and background (cozy winter palette with improved contrast)
  foreground = '#e5dfc8',  -- text: brighter warm beige for better readability
  background = '#0E1012',  -- base: slightly darker for more contrast
  
  -- Cursor colors (soft aqua accent - brighter for visibility)
  cursor_bg = '#9dd9ad',   -- brighter aqua/green
  cursor_fg = '#232a2e',
  cursor_border = '#9dd9ad',
  
  -- Selection colors (more distinct)
  selection_bg = '#3d484d',  -- surface2: lighter than base
  selection_fg = '#e5dfc8',  -- brighter text
  
  -- Split/pane border colors
  split = '#5a6268',  -- slightly lighter for visibility
  
  -- ANSI colors (normal) - Enhanced contrast while keeping winter aesthetic
  ansi = {
    '#3d484d',  -- black (darker surface)
    '#f2a0a3',  -- red (brighter for visibility)
    '#b4d89f',  -- green (more vibrant lime)
    '#e9d5a1',  -- yellow (brighter)
    '#99cec7',  -- blue (more vibrant aqua)
    '#e5b5d1',  -- magenta/purple (brighter)
    '#9dd9ad',  -- cyan (brighter aqua)
    '#e5dfc8',  -- white (brighter text)
  },
  
  -- ANSI colors (bright) - More vivid for better distinction
  brights = {
    '#5a6268',  -- bright black (overlay0)
    '#ffbac0',  -- bright red (more vivid)
    '#c9e5b0',  -- bright green (more vivid)
    '#f5e6ba',  -- bright yellow (more vivid)
    '#b3e0db',  -- bright blue (more vivid)
    '#f2cfdf',  -- bright magenta (more vivid)
    '#b8f0c8',  -- bright cyan (more vivid)
    '#f5f0e0',  -- bright white (almost white for maximum contrast)
  },
  
  -- Tab bar colors (matching winter aesthetic with better contrast)
  tab_bar = {
    background = '#1a2024',  -- mantle: darker for more contrast
    active_tab = {
      bg_color = '#83c092',  -- green/aqua accent (brighter)
      fg_color = '#1a2024',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#2e383d',  -- slightly lighter surface
      fg_color = '#b0bcb3',  -- brighter subtext
    },
    inactive_tab_hover = {
      bg_color = '#3d484d',  -- surface1
      fg_color = '#e5dfc8',
    },
    new_tab = {
      bg_color = '#2e383d',
      fg_color = '#b0bcb3',
    },
    new_tab_hover = {
      bg_color = '#3d484d',
      fg_color = '#e5dfc8',
    },
  },
}

-- ============================================================================
-- FONT SETTINGS
-- ============================================================================
config.font = wezterm.font_with_fallback {
  'JetBrainsMono NF',
  'Cascadia Code',
  'Consolas',
  'Courier New',
}
config.font_size = 12.5
config.line_height = 1.2

-- Shells & domains (Windows)
config.default_prog = { 'powershell.exe', '-NoLogo' }
config.wsl_domains = wezterm.default_wsl_domains()

-- Leader-based keybindings (Ctrl+a)
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1500 }
config.keys = {
  -- Tabs
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },

  -- Misc
  { key = 'f', mods = 'LEADER', action = act.ToggleFullScreen },
  { key = 'b', mods = 'LEADER', action = act.EmitEvent('toggle-colorscheme') },
  { key = 'P', mods = 'LEADER|SHIFT', action = act.ActivateCommandPalette },
  { key = '+', mods = 'CTRL|SHIFT', action = act.IncreaseFontSize },
  { key = '_', mods = 'CTRL|SHIFT', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },

  -- NEW: open launch menu with Leader+s 
  { key = 's', mods = 'LEADER', action = act.ShowLauncher },
}

-- Toggle between dark/light schemes
local is_dark = true
wezterm.on('toggle-colorscheme', function(window, _)
  is_dark = not is_dark
  window:set_config_overrides({ color_scheme = is_dark and scheme_dark or scheme_light })
end)

-- Right status: battery + time
wezterm.on('update-right-status', function(window, _)
  local bat = ''
  for _, b in ipairs(wezterm.battery_info()) do
    bat = string.format(' %.0f%% ', b.state_of_charge * 100)
    break
  end
  local date = wezterm.strftime ' %Y-%m-%d %H:%M '
  window:set_right_status(wezterm.format({ { Text = bat .. date } }))
end)

-- Optional: quick launch menu entries (WezTerm also auto-discovers WSL/pwsh)
config.launch_menu = {
  { label = 'Windows PowerShell', args = { 'powershell.exe', '-NoLogo' } },
  { label = 'Command Prompt', args = { 'cmd.exe' } },
  -- WSL Ubuntu, start in Linux home 
  { label = 'WSL Ubuntu (Home)', args = { 'wsl.exe', "-d", "Ubuntu", "--cd", "~" } },
}

config.default_prog = nil

return config

