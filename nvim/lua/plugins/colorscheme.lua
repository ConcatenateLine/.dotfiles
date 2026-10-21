-- Custom colorscheme: evergarden (carried over from the previous LunarVim setup).
--
-- `evergarden` is loaded before LazyVim (priority 10000) so that its `setup()`
-- has already stored the custom palette by the time LazyVim applies the
-- colorscheme: LazyVim applies it at the end of its own setup, and start
-- plugins are sorted by priority (descending).
--
-- `LazyVim.config.setup()` force-merges the `opts` of the LazyVim spec into its
-- config, so `colorscheme` here replaces the default `require("tokyonight").load()`.
-- A function is used instead of the `"evergarden"` string so that it does not
-- depend on `colors/evergarden.lua` already being in the runtimepath.
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("evergarden").load()
      end,
    },
  },
  {
    "evergardentheme/nvim",
    name = "evergarden",
    priority = 100000,
    lazy = false,
    opts = {
      theme = {
        variant = "fall",
        accent = "green",
      },
      editor = {
        transparent_background = false,
        sign = { color = "none" },
        float = { color = "mantle", solid_border = false },
        completion = { color = "surface0" },
      },
    },
  },
}
