local options = {
  defaults = {
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
    previewer = true,
    preview = true,
    file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,
  },
  pickers = {
    find_files = {
      theme = "dropdown",
    },
    live_grep  = {
      theme = "dropdown",
    },
    buffers    = {
      theme = "dropdown",
    }
  },
  extensions = {
    file_browser = {
      theme = "ivy",
      hijack_netrw = true,
    },
  },
  extensions_list = {
    "file_browser",
  },
}

return options
