require "nvchad.mappings"

local map = vim.keymap.set

-- ── Diagnostics ─────────────────────────────────────────────────────────────
local diagnostics_visible = true

map("n", "<leader>lx", function()
  diagnostics_visible = not diagnostics_visible
  vim.diagnostic.config {
    virtual_text = diagnostics_visible,
    underline = diagnostics_visible,
  }
end, { desc = "LSP Toggle diagnostic virtual text" })

-- ── Telescope ───────────────────────────────────────────────────────────────
-- NvChad already provides: <leader>ff find files, <leader>fw live grep,
-- <leader>fb buffers, <leader>fo oldfiles, <leader>fh help, <leader>fz fuzzy
-- find in buffer, <leader>ma marks, <leader>cm git commits, <leader>gt git
-- status. These add back the aliases you had muscle memory for.
map("n", "<leader>fg", function()
  require("telescope.builtin").live_grep()
end, { desc = "Telescope Find with grep" })

map("n", "<leader>fi", function()
  require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "Telescope Fuzzy find in current file" })

map("n", "<leader>fn", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>", {
  desc = "Telescope File browser",
})

-- ── Leap ────────────────────────────────────────────────────────────────────
-- Tracking upstream on Codeberg. Two things changed vs the version you were
-- running:
--
--   1. The `leap.remote` module is gone. It was replaced by "visitor mode"
--      (`leap.visit`), which does the same job -- jump somewhere, act, come
--      back -- but generalised beyond text objects.
--
--   2. Remote text objects are no longer 36 separate mappings. `ir` and `ar`
--      are now prefixes that prompt for the object character. The keystrokes
--      you already know are unchanged: `irw`, `arp`, `ir(` all still work.
--
-- Reference: :h leap-mappings and :h leap.visit-mappings

map({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
map({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })
map({ "n", "x", "o" }, "<leader>s", "<Plug>(leap-from-window)", { desc = "Leap to other window" })

-- Visitor mode: operate at a remote location, then return.
-- `ir`/`ar` replace your old remote text objects.
map({ "x", "o" }, "ir", "<Plug>(leap-visit-inner-text-object)", { desc = "Leap visit i<textobj>" })
map({ "x", "o" }, "ar", "<Plug>(leap-visit-text-object)", { desc = "Leap visit a<textobj>" })

-- NEW (not in your old config -- upstream's suggested binding, delete if you
-- don't want it). Starts a remote visual selection: `Vgs{leap}p` swaps lines.
-- Overrides vim's `gs` (sleep), which is rarely used.
map({ "n", "x", "o" }, "gs", "<Plug>(leap-visit)", { desc = "Leap visit (remote select)" })

-- Hide the real cursor while leaping.
local leap_group = vim.api.nvim_create_augroup("UserLeapCursor", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = leap_group,
  pattern = "LeapEnter",
  callback = function()
    vim.cmd.hi("Cursor", "blend=100")
    vim.opt.guicursor:append { "a:Cursor/lCursor" }
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = leap_group,
  pattern = "LeapLeave",
  callback = function()
    vim.cmd.hi("Cursor", "blend=0")
    vim.opt.guicursor:remove { "a:Cursor/lCursor" }
  end,
})

-- OPTIONAL, and worth trying once the basics work: auto-paste on returning
-- from a visit. Makes `Vgs{leap}p` swap two regions and `ygs{leap}` clone one.
-- See :h leap.visit-autopaste
--
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "VisitDone",
--   group = vim.api.nvim_create_augroup("UserLeapVisit", { clear = true }),
--   callback = function(event)
--     local mode = event.data.mode
--     if
--       event.data.register == '"'
--       and (mode:match("^[vV\22]") or (vim.v.operator == "y"))
--     then
--       vim.cmd "normal! p"
--     end
--   end,
-- })

-- Diagnostic: run :LeapInfo if a leap key stops working after an update.
vim.api.nvim_create_user_command("LeapInfo", function()
  local plugs = {
    "<Plug>(leap-forward)",
    "<Plug>(leap-backward)",
    "<Plug>(leap-from-window)",
    "<Plug>(leap-anywhere)",
    "<Plug>(leap-visit)",
    "<Plug>(leap-visit-text-object)",
    "<Plug>(leap-visit-inner-text-object)",
  }

  local lines = {}
  for _, name in ipairs(plugs) do
    local found = false
    for _, mode in ipairs { "n", "x", "o" } do
      if vim.fn.maparg(name, mode) ~= "" then
        found = true
        break
      end
    end
    table.insert(lines, (found and "  ok      " or "  MISSING ") .. name)
  end

  table.insert(lines, (pcall(require, "leap.visit") and "  ok      " or "  MISSING ") .. "leap.visit module")
  vim.notify("leap.nvim:\n" .. table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Show which leap.nvim mappings are available" })

-- ── Rust: cargo run in a reusable terminal split ─────────────────────────────
local function find_cargo_terminal()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "terminal" then
      if vim.api.nvim_buf_get_name(buf):match "CargoRun" then
        return buf
      end
    end
  end
  return nil
end

local function find_window_for_buf(buf)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return win
    end
  end
  return nil
end

local function open_cargo_terminal()
  vim.cmd "botright vsplit | terminal cargo run --color=always"
  vim.api.nvim_buf_set_name(vim.api.nvim_get_current_buf(), "CargoRun")
  vim.cmd "startinsert"
end

map("n", "<leader>m", function()
  local buf = find_cargo_terminal()

  if not buf then
    open_cargo_terminal()
    return
  end

  local win = find_window_for_buf(buf)
  if win then
    vim.api.nvim_set_current_win(win)
  else
    vim.cmd "botright vsplit"
    vim.api.nvim_set_current_buf(buf)
  end

  local chan = vim.b[buf].terminal_job_id
  if chan and vim.fn.jobwait({ chan }, 0)[1] == -1 then
    vim.api.nvim_chan_send(chan, "clear && cargo run --color=always\n")
    vim.cmd "startinsert"
  else
    open_cargo_terminal()
  end
end, { desc = "Rust Run cargo in terminal" })
