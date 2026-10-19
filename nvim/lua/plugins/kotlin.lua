-- kotlin-language-server из extra lang.kotlin падает на initialize в проектах без Gradle/Maven:
-- nvim-lspconfig кладёт в init_options storagePath = корень по build-файлам, корня нет →
-- таблица пустая, nvim шлёт её JSON-массивом [], а сервер ждёт объект. Пустые init_options
-- не отправляем: сервер тогда работает так же, как без storagePath.
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      kotlin_language_server = {
        before_init = function(params)
          if vim.tbl_isempty(params.initializationOptions or {}) then
            params.initializationOptions = nil
          end
        end,
      },
    },
  },
}
