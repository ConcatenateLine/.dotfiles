-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
-- This is theuser config

lvim.plugins = {
  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow"
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  { "nvim-treesitter/nvim-treesitter-angular" },
  {
    "sphamba/smear-cursor.nvim",

    opts = {
      -- Smear cursor when switching buffers or windows.
      smear_between_buffers = true,

      -- Smear cursor when moving within line or to neighbor lines.
      -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
      smear_between_neighbor_lines = true,

      -- Draw the smear in buffer space instead of screen space when scrolling
      scroll_buffer_space = true,

      -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
      -- Smears will blend better on all backgrounds.
      legacy_computing_symbols_support = false,

      -- Smear cursor in insert mode.
      -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
      smear_insert_mode = true,
    },
  },
  {
    -- jump to characters
    'smoka7/hop.nvim',
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    end
  },
  {
    "folke/trouble.nvim",
    opts = {
      auto_preview = false
    }, -- for default options, refer to the configuration section for custom setup.
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
    -- Todo: Fork for improved performance
    -- Open url in a browser
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
      vim.keymap.set('i', '<M-c>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<M-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
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
    -- functionality of telescope-fzy-native: fuzzy finder with native fzy library for better performance
    "nvim-telescope/telescope-fzy-native.nvim",
    build = "make",
    event = "BufRead",
  },
  {
    -- functionality: fuzzy finder, tags, file browser, and more
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
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "marilari88/neotest-vitest",
      'thenbe/neotest-playwright',
      dependencies = 'nvim-telescope/telescope.nvim',
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-vitest") {
            -- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
            filter_dir = function(name, rel_path, root)
              return name ~= "node_modules"
            end,
          },
          require('neotest-playwright').adapter({
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
            },
            -- Filter directories when searching for test files. Useful in large
            -- projects (see performance notes).
            filter_dir = function(name, rel_path, root)
              return name ~= 'node_modules'
            end,
          }),
        }
      })
    end
  },
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Enhanced context for full-stack development
        -- contexts = {
        --   -- Include package.json for Node.js projects
        --   package = function()
        --     local package_json = vim.fn.findfile('package.json', '.;')
        --     return package_json ~= '' and vim.fn.readfile(package_json) or nil
        --   end,
        --   -- Include API routes/docs for backend context
        --   api_docs = function()
        --     local api_files = vim.fn.glob('**/*api*.{js,ts,py,go,rs}', false, true)
        --     return #api_files > 0 and api_files or nil
        --   end,
        --   -- Include database schema files
        --   schema = function()
        --     local schema_files = vim.fn.glob('**/*schema*.{sql,prisma,json}', false, true)
        --     return #schema_files > 0 and schema_files or nil
        --   end,
        -- },
        -- Custom prompts for full-stack workflows
        prompts = {
          api = "Create/modify API endpoint for @this following REST conventions",
          component = "Create React/Vue component for @this with TypeScript",
          test = "Write comprehensive tests for @this including unit and integration tests",
          refactor = "Refactor @this for better performance and maintainability",
          debug = "Debug @this and identify potential issues",
          deploy = "Generate deployment configuration for @this",
        },
        -- Enhanced provider settings
        provider = {
          enabled = "snacks",
          snacks = {
            auto_start = true,
            hidden = false,
            style = {
              border = "rounded",
              title = "OpenCode AI Assistant",
            },
          },
        },
        -- Better event handling
        events = {
          reload = true,
          notify = true,
        },
        -- Integration
        lsp = {
          enabled = true,    -- LSP integration
          auto_start = true, -- Auto format
        }
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ "n", "x" }, "<M-f>", function() require("opencode").ask("@this: ", { submit = true }) end,
        { desc = "Ask opencode" })
      vim.keymap.set({ "n", "x" }, "<M-g>", function() require("opencode").select() end,
        { desc = "Execute opencode action…" })
      vim.keymap.set({ "n", "x" }, "ga", function() require("opencode").prompt("@this") end, { desc = "Add to opencode" })
      vim.keymap.set({ "n", "t" }, "<M-q>", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
      vim.keymap.set("n", "<M-up>", function() require("opencode").command("session.half.page.up") end,
        { desc = "opencode half page up" })
      vim.keymap.set("n", "<M-down>", function() require("opencode").command("session.half.page.down") end,
        { desc = "opencode half page down" })
      vim.keymap.set("n", "<M-left>", function() require("opencode").command("session.page.up") end,
        { desc = "opencode page left" })
      vim.keymap.set("n", "<M-right>", function() require("opencode").command("session.page.down") end,
        { desc = "opencode page right" })
      -- Additional scroll controls
      vim.keymap.set("n", "<M-k>", function() require("opencode").command("session.first") end,
        { desc = "opencode jump to first message" })
      vim.keymap.set("n", "<M-j>", function() require("opencode").command("session.last") end,
        { desc = "opencode jump to last message" })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      -- Example config
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
      })
    end,
  },
}

lvim.builtin.which_key.mappings["r"] = {
  name = "Replace&Todo",
  n = { "<cmd>lua require('muren.api').toggle_ui()<cr>", "Toggle muren UI" },
  f = { "<cmd>lua require('muren.api').open_fresh_ui()<cr>", "Open fresh muren UI" },
  -- Todo list
  q = { "<cmd>:TodoQuickFix<cr>", "Quickfix todo comments" },
  l = { "<cmd>:TodoTelescope<cr>", "Telescope todo comments" },
  t = { "<cmd>:TodoTrouble<cr>", "Trouble todo comments" },
  c = { "<cmd>:TodoLocList<cr>", "Location list todo comments" },
  z = { "<cmd>:TodoFzfLua<cr>", "FzfLua todo comments" },
}

lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (Trouble)" },
  b = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics (Trouble)" },
  s = { "<cmd>Trouble symbols toggle focus=true<cr>", "Symbols (Trouble)" },
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
        local msg = "No active codeium"
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
    {
      require("opencode").statusline,
    },
  }

  lualine.setup(config)
end

lvim.builtin.nvimtree.setup.actions.open_file.quit_on_open = true -- closes the tree when you open a file.

lvim.autocommands = {
  {
    "BufRead",
    {
      pattern = "*",
      callback = function()
        -- Close unnamed buffer when opening a file
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) and
              vim.api.nvim_buf_get_name(buf) == "" and
              vim.bo[buf].buflisted then
            vim.api.nvim_buf_delete(buf, { force = true })
            break
          end
        end
      end
    }
  },
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
    if vim.fn.argc() == 0 then
      require("alpha").start()
    end
  end,
})

-- LSP setup
require("lvim.lsp.manager").setup("angularls")

local formatters = require "lvim.lsp.null-ls.formatters"

formatters.setup {
  { command = "markdownlint", filetypes = { "markdown" } },
}
