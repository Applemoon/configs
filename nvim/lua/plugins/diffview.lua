return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      -- worktree vs HEAD in one diff (IDEA-style), not worktree vs index
      { "<leader>gv", "<cmd>DiffviewOpen HEAD<cr>", desc = "Diffview vs HEAD" },
    },
    opts = {
      hooks = {
        diff_buf_win_enter = function(_, winid)
          vim.wo[winid].wrap = true
        end,
      },
    },
  },
}
