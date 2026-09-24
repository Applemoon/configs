-- markdownlint-cli2 не ищет конфиг в ~ (только cwd и ниже), поэтому глобальный
-- базовый конфиг передаётся через --config. Конфиг проекта, если есть, ложится поверх.
return {
  "mfussenegger/nvim-lint",
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        prepend_args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint.yaml" },
      },
    },
  },
}
