# Neovim (LazyVim)

Neovim configuration based on [LazyVim](https://github.com/LazyVim/LazyVim),
powered by [lazy.nvim](https://github.com/folke/lazy.nvim).

Replaces the previous LunarVim setup.

## Requirements

| Requirement | Version | Provided by |
|-------------|---------|-------------|
| Neovim | >= 0.11.2 (LazyVim hard requirement) | `pkgs.neovim` from `nixpkgs-unstable` (0.12.6) |
| Git | >= 2.19.0 | `pkgs.git` |
| tree-sitter CLI | any | `pkgs.tree-sitter` (needed by `nvim-treesitter` `main` branch) |
| C compiler | any | `pkgs.gcc` (builds treesitter parsers) |
| fd / ripgrep / fzf | any | `pkgs.fd`, `pkgs.ripgrep`, `pkgs.fzf` (file finding) |
| curl | any | `pkgs.curl` (completion engine downloads) |

## Layout

```
nvim/
├── init.lua                  # bootstrap: require("config.lazy")
├── lazy-lock.json            # pinned plugin versions (commit to this file)
├── stylua.toml               # formatter config
└── lua/
    ├── config/
    │   ├── lazy.lua          # lazy.nvim setup: LazyVim import + plugin specs
    │   ├── options.lua       # editor options (loaded before startup)
    │   ├── keymaps.lua       # keymaps (loaded on VeryLazy)
    │   └── autocmds.lua      # autocmds (loaded on VeryLazy)
    └── plugins/
        ├── colorscheme.lua   # evergarden colorscheme (custom palette)
        └── opencode.lua      # OpenCode integration (snacks provider)
```

`~/.config/nvim` is symlinked to `~/.dotfiles/nvim` by home-manager
(out-of-store symlink), so `lazy-lock.json` updates land in this repository.

## Bootstrapping

There is no installer. On the first launch, `lazy.nvim` clones itself and
installs the plugins:

```bash
nvim          # first run installs everything
```

Sync/update explicitly:

```bash
nvim --headless "+Lazy! sync" +qa
```

## Colorscheme

The editor uses [evergarden](https://github.com/evergardentheme/nvim) (variant
`fall`, accent `green`), carried over from the previous LunarVim setup. It is
configured in `nvim/lua/plugins/colorscheme.lua`, which also overrides
LazyVim's `opts.colorscheme` so that the custom palette is applied instead of
the default tokyonight.

The plugin is loaded with a priority higher than LazyVim's, because LazyVim
applies the colorscheme at the end of its own setup — the palette has to be
stored first.

The same evergarden palette is used by the terminal
(`windows/Users/username/.wezterm.lua`) and by the OpenCode TUI
(`evergarden-winter`, see `opencode/themes/`).

## Adding plugins

Add a spec under `nvim/lua/plugins/`, e.g. `nvim/lua/plugins/markdown.lua`:

```lua
return {
  { "LazyVim/LazyVim", import = "lazyvim.plugins.extras.lang.markdown" },
}
```

LazyVim "extras" are the supported way to add batteries: `:LazyExtras` lists
them interactively.

## Keymaps

Default LazyVim keymaps are documented at
<https://lazyvim.github.io/keymaps.html>. The only custom ones are the
OpenCode bindings:

| Key | Mode | Action |
|-----|------|--------|
| `<M-f>` | Normal, Visual | Ask OpenCode (`@this`) |
| `<M-g>` | Normal, Visual | Open the OpenCode action picker |
| `ga` | Normal, Visual | Send `@this` to OpenCode |
| `<M-q>` | Normal, Terminal | Toggle the OpenCode terminal |
| `<M-up>` / `<M-down>` | Normal | OpenCode session: half page up/down |
| `<M-left>` / `<M-right>` | Normal | OpenCode session: page up/down |
| `<M-k>` / `<M-j>` | Normal | OpenCode session: first/last message |

## Troubleshooting

```bash
nvim --headless "+checkhealth" +qa   # lazy.nvim / treesitter / lsp health
:Lazy                                # plugin manager UI
:Lazy sync                           # reinstall/update plugins
```
