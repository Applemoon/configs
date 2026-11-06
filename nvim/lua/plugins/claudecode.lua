-- Claude Code runs in its own terminal and attaches to Neovim with /ide, so the plugin never starts a second Claude
-- inside Neovim. <leader>as sends the selection from a diffview diff too: the plugin rejects a diffview:// buffer,
-- so the right-hand side (the branch's HEAD) goes out as the real file in the work tree.
local function send_selection()
  local s, e = vim.fn.line("v"), vim.fn.line(".")
  if s > e then
    s, e = e, s
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  local path = vim.api.nvim_buf_get_name(0)
  if path:match("^diffview://") then
    local view = require("diffview.lib").get_current_view()
    local main = view and view.cur_layout and view.cur_layout:get_main_win()
    if not main or main.id ~= vim.api.nvim_get_current_win() then
      vim.notify("Claude: select on the right-hand side of the diff, the left one is the base", vim.log.levels.WARN)
      return
    end
    path = main.file.adapter.ctx.toplevel .. "/" .. main.file.path
  end
  require("claudecode").send_at_mention(path, s - 1, e - 1, "ClaudeCodeSend")
end

return {
  {
    "coder/claudecode.nvim",
    -- the extra loads it on its keys only, and /ide finds no Neovim until its server runs
    event = "VeryLazy",
    opts = {
      terminal = { provider = "none" },
    },
    keys = {
      { "<leader>as", send_selection, mode = "v", desc = "Send to Claude (diffview too)" },
    },
  },
}
