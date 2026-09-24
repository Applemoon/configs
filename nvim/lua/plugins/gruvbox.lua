return {
  { "ellisonleao/gruvbox.nvim", opts = { contrast = "hard" } },
  -- Тема через LazyVim, иначе он сначала грузит свой tokyonight, а потом её перекрашивают
  { "LazyVim/LazyVim", opts = { colorscheme = "gruvbox" } },
}
