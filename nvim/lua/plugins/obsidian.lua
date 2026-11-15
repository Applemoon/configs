-- Obsidian vaults in nvim: [[ completion, backlinks and tags through fzf-lua, <CR> on a checkbox toggles it.
-- frontmatter.enabled = false only stops writing it: otherwise every save of a vault note adds id/aliases/tags
-- and re-sorts the keys; reading aliases and tags still works. A new note keeps its title as the file name
-- (Cyrillic and emoji included), not a zettel id or a lowercase slug. Its own UI turns itself off while
-- render-markdown is installed.
return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    cmd = "Obsidian",
    opts = {
      legacy_commands = false,
      workspaces = vim.tbl_filter(function(w)
        return vim.uv.fs_stat(vim.fn.expand(w.path)) ~= nil
      end, {
        { name = "personal", path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/My vault" },
        { name = "work", path = "~/Developer/work-vault" },
      }),
      picker = { name = "fzf-lua" },
      frontmatter = { enabled = false },
      note_id_func = function(title)
        return title or require("obsidian.builtin").zettel_id()
      end,
      checkbox = { order = { " ", "x" } },
      footer = { enabled = false },
    },
  },
}
