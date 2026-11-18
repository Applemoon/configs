return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Где я в файле: полоска из 8 делений перед штатными процентами и позицией
      table.insert(opts.sections.lualine_y, 1, function()
        local filled = math.floor(vim.fn.line(".") / vim.fn.line("$") * 8 + 0.5)
        return string.rep("█", filled) .. string.rep("░", 8 - filled)
      end)
    end,
  },
}
