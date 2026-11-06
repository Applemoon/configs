-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.winbar = "%=%m %f"

-- Без автоформата при сохранении: в командных репо ktlint/jdtls/markdownlint --fix
-- переписывают файл не по стилю команды. Форматировать вручную: <leader>cf.
vim.g.autoformat = false

-- Корень для поиска (<leader>sw, <leader>sg, <leader><space>) - git-репозиторий, а не корень LSP:
-- корень сервера бывает Maven-модулем (у kotlin-lsp - если в корне репо нет pom.xml), и поиск из файла
-- видел один модуль, а из диффа (там LSP нет) - весь репозиторий.
vim.g.root_spec = { { ".git", "lua" }, "cwd" }
