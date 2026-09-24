-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.winbar = "%=%m %f"

-- Без автоформата при сохранении: в командных репо ktlint/jdtls/markdownlint --fix
-- переписывают файл не по стилю команды. Форматировать вручную: <leader>cf.
vim.g.autoformat = false
