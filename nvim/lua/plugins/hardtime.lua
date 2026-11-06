-- The plugin's defaults: blocks hjkl, +, gj/gk and friends after 3 presses within a second, the arrows and the
-- mouse outright (not in its excluded filetypes, Diffview.* among them), hints at better motions as they happen;
-- :Hardtime report lists the most frequent ones
return {
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
  },
}
