-- Mirrors the structure of NvChad's nvconfig.lua:
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",
  theme_toggle = { "catppuccin", "one_light" },

  -- extra base46 integrations to compile (plugins outside NvChad's defaults)
  integrations = { "notify" },

  hl_override = {
    NvDashAscii = { bg = "NONE", fg = "blue" },
    NvDashButtons = { bg = "NONE" },
    Terminal = { fg = "#cdd6f4", bg = "#1e1e2e" },
    TerminalBold = { fg = "#f5c2e7", bg = "#1e1e2e", bold = true },
    -- Comment = { italic = true },
    -- ["@comment"] = { italic = true },
  },

  hl_add = {},
}

M.ui = {
  telescope = { style = "borderless" }, -- borderless / bordered

  statusline = {
    theme = "default", -- default/vscode/vscode_colored/minimal
    separator_style = "default",
  },

  tabufline = {
    enabled = true,
    lazyload = true,
  },
}

M.lsp = { signature = true }

M.term = {
  startinsert = true,
  base46_colors = true,
}

M.nvdash = {
  load_on_startup = true,

  header = {
    " ▄██▄       ▄█ ██████▀",
    "█▄▀███▄    ███ ▀▀▀▀▀  ",
    "███ ▀███▄  ███        ",
    "███   ▀███ ███        ",
    "███     ▀█ ███        ",
    "███ ▄▄▄▄▄ ▄██▀▄▄▄▄▄▄  ",
    " ▀█ ██████▄▀▄████████▄",
    "                      ",
    " 󱐋 Powered by  eovim ",
    "                      ",
  },

  buttons = {
    { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
    { txt = "󰈚  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
    { txt = "󰈭  Find Word", keys = "fg", cmd = "Telescope live_grep" },
    { txt = "  Bookmarks", keys = "ma", cmd = "Telescope marks" },
    { txt = "  Git Status", keys = "gt", cmd = "Telescope git_status" },
    { txt = "  Git Commits", keys = "cm", cmd = "Telescope git_commits" },
    { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
    { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashFooter",
      no_gap = true,
      content = "fit",
    },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  },
}

-- Mason packages NvChad installs on first launch. Replaces the old
-- ensure_installed table + custom :MasonInstallAll command.
M.mason = {
  pkgs = {
    -- lua
    "lua-language-server",
    "stylua",

    -- java
    "jdtls",
    "google-java-format",

    -- python
    "basedpyright",
    "ruff",

    -- typescript / javascript / web
    "typescript-language-server",
    "biome",
    "eslint-lsp",
    "prettierd",
    "html-lsp",
    "css-lsp",
    "json-lsp",

    -- rust (rustaceanvim will also accept a rustup-installed rust-analyzer)
    "rust-analyzer",

    -- go
    "gopls",
    "gofumpt",
    "goimports",

    -- solidity
    "solidity-ls",

    -- markdown
    "marksman",

    -- c / asm
    "clangd",
    "clang-format",
  },

  skip = {},
}

M.cheatsheet = {
  theme = "grid", -- simple/grid
  excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" },
}

return M
