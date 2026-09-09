local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    python = { "ruff_format" },

    javascript = { "biome" },
    javascriptreact = { "biome" },
    typescript = { "biome" },
    typescriptreact = { "biome" },
    json = { "biome" },
    jsonc = { "biome" },

    html = { "prettierd" },
    css = { "prettierd" },
    scss = { "prettierd" },
    markdown = { "prettierd" },
    yaml = { "prettierd" },

    go = { "goimports", "gofumpt" },

    java = { "google-java-format" },

    solidity = { "forge_fmt" }, -- needs foundry (`forge`) on PATH

    c = { "clang_format" },
    cpp = { "clang_format" },

    -- rust intentionally absent: rust-analyzer formats via lsp_format fallback
  },

  formatters = {
    -- Preserves the 79-column output you had from black.
    -- NOTE: passing --line-length on the CLI overrides any line-length set in
    -- a project's pyproject.toml / ruff.toml. Delete this block if you'd
    -- rather each project's own config win.
    ruff_format = {
      args = {
        "format",
        "--line-length",
        "79",
        "--force-exclude",
        "--stdin-filename",
        "$FILENAME",
        "-",
      },
    },
  },

  -- Filetypes with no entry above fall back to the language server.
  default_format_opts = {
    lsp_format = "fallback",
  },

  format_on_save = function(bufnr)
    -- escape hatch: :FormatDisable / :FormatEnable (see lua/autocmds.lua)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 1000, lsp_format = "fallback" }
  end,
}

return options
