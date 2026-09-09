-- NvChad's shared on_attach (keymaps), on_init and capabilities.
-- Applied to every server via vim.lsp.config("*", ...).
require("nvchad.configs.lspconfig").defaults()

-- ── Servers that need no extra config ───────────────────────────────────────
-- Definitions come from nvim-lspconfig's lsp/<name>.lua files.
local servers = {
  "html",
  "cssls",
  "jsonls",
  "ts_ls",
  "biome",
  "eslint",
  "basedpyright",
  "ruff",
  "jdtls",
  "gopls",
  "solidity_ls",
  "clangd",
  "marksman",
}

-- ── Per-server overrides ────────────────────────────────────────────────────
-- vim.lsp.config(name, opts) merges into the shipped definition.
-- See :h vim.lsp.config

-- C / C++ / assembly
vim.lsp.config("clangd", {
  filetypes = { "c", "cpp", "objc", "objcpp", "asm" },
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=bundled",
    "--header-insertion=iwyu",
  },
  init_options = {
    clangdFileStatus = true,
    usePlaceholders = true,
    completeUnimported = true,
    semanticHighlighting = true,
  },
})

-- Python: basedpyright for types, ruff for lint + import sorting.
vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        typeCheckingMode = "standard", -- off / basic / standard / strict / all
      },
    },
  },
})

vim.lsp.config("ruff", {
  -- basedpyright owns hover; two servers answering K is noise.
  on_attach = function(client, _)
    client.server_capabilities.hoverProvider = false
  end,
})

-- Go
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
        unusedwrite = true,
        nilness = true,
      },
    },
  },
})

-- Solidity
vim.lsp.config("solidity_ls", {
  filetypes = { "solidity" },
})

-- JSON
-- NOTE: for real schema validation, add b0o/SchemaStore.nvim and set
--   schemas = require("schemastore").json.schemas()
-- The old hard-coded wrangler schema URL here was broken and has been dropped.
vim.lsp.config("jsonls", {
  filetypes = { "json", "jsonc" },
  settings = {
    json = {
      validate = { enable = true },
    },
  },
})

-- NOTE: rust_analyzer is deliberately NOT listed above.
-- rustaceanvim owns it (see lua/plugins/init.lua). Enabling it here too would
-- start two copies of the server.

vim.lsp.enable(servers)
