-- markdownlint-cli2 из extra lang.markdown выключен: его диагностика (MD029 и прочие)
-- в личных заметках и командных доках только шумит. Без его диагностики не срабатывает
-- и одноимённый форматтер conform (у него condition на source == "markdownlint").
return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    opts.linters_by_ft = opts.linters_by_ft or {}
    opts.linters_by_ft.markdown = {}
  end,
}
