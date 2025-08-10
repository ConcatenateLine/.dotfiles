-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
-- This is theuser config

lvim.plugins = {
  {
    'smoka7/hop.nvim',
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    end
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufRead",
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require('symbols-outline').setup()
    end
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "felipec/vim-sanegx",
    event = "BufRead",
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    -- --@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    config = function()
      CustomOilBar = function()
        local path = vim.fn.expand "%"
        path = path:gsub("oil://", "")

        return "  " .. vim.fn.fnamemodify(path, ":.")
      end

      require("oil").setup {
        columns = { "icon" },
        keymaps = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          ["<M-h>"] = "actions.select_split",
        },
        win_options = {
          winbar = "%{v:lua.CustomOilBar()}",
        },
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, _)
            local folder_skip = { "dev-tools.locks", "dune.lock", "_build" }
            return vim.tbl_contains(folder_skip, name)
          end,
        },
      }

      -- Open parent directory in current window
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

      -- Open parent directory in floating window
      vim.keymap.set("n", "<space>-", require("oil").toggle_float)
    end,
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
  {
    'ray-x/aurora',
    init = function()
      vim.g.aurora_italic = 1
      vim.g.aurora_transparent = 1
      vim.g.aurora_bold = 1
    end,
    config = function()
      vim.cmd.colorscheme "aurora"
      -- override defaults
      vim.api.nvim_set_hl(0, '@number', { fg = '#e933e3' })
    end
  },
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup({
        -- ...
      })

      vim.cmd('colorscheme github_dark_default')
    end,
  },
  {
    'everviolet/nvim',
    name = 'evergarden',
    priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
    opts = {
      theme = {
        variant = 'fall', -- 'winter'|'fall'|'spring'|'summer'
        accent = 'green',
      },
      editor = {
        transparent_background = false,
        sign = { color = 'none' },
        float = {
          color = 'mantle',
          invert_border = false,
        },
        completion = {
          color = 'surface0',
        },
      },
    }
  },
  {
    'Exafunction/codeium.vim',
    config = function()
      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end,
        { expr = true, silent = true })
      vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
        { expr = true, silent = true })
      vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    end
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },
  {
    "nvim-telescope/telescope-fzy-native.nvim",
    build = "make",
    event = "BufRead",
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    opts = {}
  },
  -- Replace experience in Nvim
  {
    "AckslD/muren.nvim",
    config = function()
      require("muren").setup()
    end
  },
 }

lvim.builtin.which_key.mappings["r"] = {
  name = "Replace",
  n = { "<cmd>lua require('muren.api').toggle_ui()<cr>", "Toggle muren UI" },
  f = { "<cmd>lua require('muren.api').open_fresh_ui()<cr>", "Open fresh muren UI" },
}

lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (Trouble)" },
  b = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics (Trouble)" },
  s = { "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols (Trouble)" },
  r = { "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", "LSP Definitions / references/ ... (Trouble)" },
  l = { "<cmd>Trouble loclist toggle<cr>", "Location list (Trouble)" },
  q = { "<cmd>Trouble qflist toggle<cr>", "Quickfix List (Trouble)" },
}

lvim.transparent_window = true

lvim.colorscheme = "evergarden"

lvim.builtin.lualine.on_config_done = function(lualine)
  local config = lualine.get_config()

  config.options.globalstatus = true
  config.options.theme = "auto"
  config.options.component_separators = { left = '', right = '' }
  config.options.section_separators = { left = '', right = '' }
  config.options.component_separators = { left = '', right = '' }
  config.options.section_separators = { left = ' ', right = ' ' }

  config.sections.lualine_c = {
    "diff",
    "diagnostics",
  }

  config.sections.lualine_x = { "fileformat", "filetype", "encoding", }

  config.sections.lualine_y = {
    "progress",
    "location",
    {
      function()
        local msg = "No active cadeium"
        local codeium = vim.fn["codeium#GetStatusString"]()
        if codeium ~= nil then
          msg = codeium
        end
        return msg
      end,
      icon = " IA:",
    }
  }

  config.sections.lualine_z = {
    "filename",
  }

  lualine.setup(config)
end

lvim.autocommands = {
  {
    "BufDelete",
    {
      pattern = "*",
      callback = function()
        vim.schedule(function()
          local api = vim.api
          local listed = vim.tbl_filter(function(buf)
            return api.nvim_buf_is_valid(buf)
                and vim.bo[buf].buflisted
                and api.nvim_buf_get_name(buf) ~= ""
          end, api.nvim_list_bufs())

          if #listed == 0 then
            vim.cmd("Alpha")
          end
        end)
      end,
    },
  },
}

-- Auto launch Alpha dasboard if no file is opened

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    if vim.fn.argc() == 0 then require("alpha").start() end
  end,
})

