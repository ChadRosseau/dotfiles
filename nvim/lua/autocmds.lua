require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- ── Terminal ────────────────────────────────────────────────────────────────
-- NvChad's own terminals are themed by base46 (see M.term in chadrc.lua).
-- This covers plain `:terminal` buffers.
autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("UserTermOpen", { clear = true }),
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Terminal", { fg = "#cdd6f4", bg = "#1e1e2e" })
    vim.api.nvim_set_hl(0, "TerminalBold", { fg = "#f5c2e7", bg = "#1e1e2e", bold = true })
    vim.cmd "startinsert"
  end,
})

-- ── Rust ────────────────────────────────────────────────────────────────────
-- :make runs cargo and populates the quickfix list.
autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserRustMake", { clear = true }),
  pattern = "rust",
  callback = function()
    vim.bo.makeprg = "cargo run --color=always"
    vim.bo.errorformat = "%f:%l:%c: %m"
  end,
})

-- ── LSP formatting ownership ────────────────────────────────────────────────
-- conform.nvim owns formatting for these filetypes. Turning the capability off
-- here stops the language server from fighting it (and stops two servers
-- attached to the same buffer from fighting each other).
autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspNoFormat", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local no_format = {
      ts_ls = true,
      jsonls = true,
      html = true,
      cssls = true,
      basedpyright = true,
      clangd = true,
      jdtls = true,
    }

    if no_format[client.name] then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end,
})

-- ── Format-on-save escape hatch ─────────────────────────────────────────────
-- :FormatDisable         turn off globally
-- :FormatDisable!        turn off for this buffer only
-- :FormatEnable          turn back on everywhere
vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, { desc = "Disable format-on-save", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = "Re-enable format-on-save" })
