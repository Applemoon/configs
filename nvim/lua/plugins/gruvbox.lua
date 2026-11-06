return {
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      contrast = "hard",
      -- Фоны диффа темнее штатных: на светло-оливковом DiffAdd комментарии и ключевые слова почти не читались
      overrides = {
        DiffAdd = { bg = "#32361a" },
        DiffDelete = { bg = "#3c1f1e" },
        DiffChange = { bg = "#0d3138" },
      },
    },
  },
  -- Тема через LazyVim, иначе он сначала грузит свой tokyonight, а потом её перекрашивают
  { "LazyVim/LazyVim", opts = { colorscheme = "gruvbox" } },
}
