return {
  -- ── Formatting ────────────────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- format on save
    opts = require "configs.conform",
  },

  -- ── LSP ───────────────────────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- ── Treesitter ────────────────────────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- core
        "lua",
        "luadoc",
        "vim",
        "vimdoc",
        "query",
        "bash",
        "diff",
        "gitcommit",
        "regex",
        -- web
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "jsonc",
        "yaml",
        "toml",
        -- markdown
        "markdown",
        "markdown_inline",
        -- languages
        "python",
        "rust",
        "ron",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "java",
        "solidity",
        "c",
        "cpp",
        "asm",
      },
    },
  },

  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "markdown" },
    opts = {},
  },

  -- ── Rust ──────────────────────────────────────────────────────────────────
  -- Replaces the archived rust-tools.nvim. It starts and owns rust-analyzer
  -- itself, so rust_analyzer must NOT also be enabled in configs/lspconfig.lua.
  {
    "mrcjkb/rustaceanvim",
    lazy = false, -- the plugin lazy-loads itself via ftplugin
    init = function()
      local ok, nvlsp = pcall(require, "nvchad.configs.lspconfig")

      vim.g.rustaceanvim = {
        server = {
          capabilities = ok and nvlsp.capabilities or nil,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = true,
              check = { command = "clippy" },
              inlayHints = { lifetimeElisionHints = { enable = "never" } },
            },
          },
        },
      }
    end,
  },

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {},
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, { name = "crates" })
      return opts
    end,
  },

  -- ── Navigation ────────────────────────────────────────────────────────────
  -- Kept eager: the s/S mappings and the remote text objects in mappings.lua
  -- expect leap's <Plug> maps to already exist. It costs ~1ms.
  --
  -- Tracking upstream on Codeberg. The author moved the project there and
  -- gutted the GitHub repo -- `ggandor/leap.nvim` on GitHub is now a README
  -- and nothing else, so never point this back at GitHub.
  --
  -- The API moved on from the version you were running: leap.remote was
  -- replaced by leap.visit. See the notes in lua/mappings.lua, and run
  -- :LeapInfo if a key stops working after an update.
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    name = "leap.nvim",
    lazy = false,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-telescope/telescope-file-browser.nvim" },
    opts = function(_, opts)
      local previewers = require "telescope.previewers"

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        vimgrep_arguments = {
          "rg",
          "-L",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
      })

      opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
        find_files = { theme = "dropdown" },
        live_grep = { theme = "dropdown" },
        buffers = { theme = "dropdown" },
      })

      opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, {
        file_browser = {
          theme = "ivy",
          hijack_netrw = true,
        },
      })

      opts.extensions_list = opts.extensions_list or {}
      table.insert(opts.extensions_list, "file_browser")

      return opts
    end,
  },

  -- ── nvim-tree ─────────────────────────────────────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        dotfiles = false,
        custom = { "**/*.spec.ts", ".DS_Store" },
      },
      git = { enable = false, ignore = true },
      view = { width = 30, preserve_window_proportions = true },
    },
  },

  -- ── Markdown ──────────────────────────────────────────────────────────────
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_refresh_slow = 1
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_combine_preview = 1
    end,
  },

  -- ── UI ────────────────────────────────────────────────────────────────────
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      level = 2,
      minimum_width = 50,
      render = "default",
      stages = "fade_in_slide_out",
      timeout = 3000,
      top_down = false,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require "notify"
    end,
  },
}

-- ────────────────────────────────────────────────────────────────────────────
-- leap.nvim note
--
-- Upstream is https://codeberg.org/andyg/leap.nvim (not GitHub).
-- If leap ever breaks after an update, the fallback is the last commit that
-- still existed on GitHub, which is the version you ran before:
--
--   { "ggandor/leap.nvim", commit = "c6bfb191f1161fbabace1f36f578a20ac6c7642c", pin = true, lazy = false },
--
-- The maintained GitHub-hosted alternative is folke/flash.nvim.
-- ────────────────────────────────────────────────────────────────────────────
