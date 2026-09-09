require "nvchad.options"

-- Anything below overrides / adds to NvChad's defaults.
-- NvChad already sets: expandtab, shiftwidth/tabstop/softtabstop = 2, smartindent,
-- ignorecase, smartcase, mouse, number, signcolumn, splitbelow/right, termguicolors,
-- timeoutlen, undofile, updatetime, clipboard = unnamedplus, cursorline, laststatus = 3.

-- disable unused providers (faster :checkhealth, no stray warnings)
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end
