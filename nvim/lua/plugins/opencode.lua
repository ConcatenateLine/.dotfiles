-- OpenCode integration.
--
-- The plugin has no `setup()` function: it reads its options from
-- `vim.g.opencode_opts`, so they have to be set before `opencode.config` is
-- required for the first time. `init` runs before the plugin's `plugin/`
-- files are sourced, which makes it the earliest safe hook.
local opencode_opts = {
  -- Custom prompts for full-stack workflows.
  select = {
    prompts = {
      api = "Create/modify API endpoint for @this following REST conventions",
      component = "Create React/Vue component for @this with TypeScript",
      test = "Write comprehensive tests for @this including unit and integration tests",
      refactor = "Refactor @this for better performance and maintainability",
      debug = "Debug @this and identify potential issues",
      deploy = "Generate deployment configuration for @this",
    },
  },
  events = {
    enabled = true,
    reload = { enabled = true },
  },
}

local opencode_cmd = "opencode"
local terminal_opts = {
  win = {
    position = "right",
    enter = false,
  },
}

return {
  {
    "nickjvandyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    init = function()
      vim.g.opencode_opts = opencode_opts
    end,
    config = function()
      -- Required for `events.reload.enabled`.
      vim.o.autoread = true

      -- Run the OpenCode server in a snacks terminal so it can be toggled.
      require("opencode.config").opts.server.start = function()
        require("snacks.terminal").open(opencode_cmd, terminal_opts)
      end

      vim.keymap.set({ "n", "x" }, "<M-f>", function()
        require("opencode").ask("@this: ")
      end, { desc = "Ask opencode" })
      vim.keymap.set({ "n", "x" }, "<M-g>", function()
        require("opencode").select()
      end, { desc = "Execute opencode action…" })
      vim.keymap.set({ "n", "x" }, "ga", function()
        require("opencode").prompt("@this")
      end, { desc = "Add to opencode" })
      vim.keymap.set({ "n", "t" }, "<M-q>", function()
        require("snacks.terminal").toggle(opencode_cmd, terminal_opts)
      end, { desc = "Toggle opencode" })
      vim.keymap.set("n", "<M-up>", function()
        require("opencode").command("session.half.page.up")
      end, { desc = "opencode half page up" })
      vim.keymap.set("n", "<M-down>", function()
        require("opencode").command("session.half.page.down")
      end, { desc = "opencode half page down" })
      vim.keymap.set("n", "<M-left>", function()
        require("opencode").command("session.page.up")
      end, { desc = "opencode page left" })
      vim.keymap.set("n", "<M-right>", function()
        require("opencode").command("session.page.down")
      end, { desc = "opencode page down" })
      vim.keymap.set("n", "<M-k>", function()
        require("opencode").command("session.first")
      end, { desc = "opencode jump to first message" })
      vim.keymap.set("n", "<M-j>", function()
        require("opencode").command("session.last")
      end, { desc = "opencode jump to last message" })
    end,
  },
}
