return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.scroll = { enabled = false }
      -- Показывать скрытые файлы (дотфайлы) в поиске файлов и grep
      opts.picker = vim.tbl_deep_extend("force", opts.picker or {}, {
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
        },
      })
    end,
  },
}