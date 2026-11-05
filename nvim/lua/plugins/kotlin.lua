return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- JetBrains kotlin-lsp (brew cask kotlin-lsp, не mason). Корень = корень git-репо, если в нём
      -- лежит pom.xml или settings.gradle(.kts): со штатными root_markers корнем становится ближайший
      -- Maven-модуль, и gd в соседний модуль не находит определения.
      kotlin_lsp = {
        mason = false,
        cmd = { "kotlin-lsp", "--stdio" },
        root_dir = function(bufnr, on_dir)
          -- Буфер не с диска (jar:/…, jrt:/… после gd в библиотеку) второй сервер не поднимает.
          if not vim.api.nvim_buf_get_name(bufnr):match("^/") then
            return
          end
          local git = vim.fs.root(bufnr, ".git")
          for _, marker in ipairs({ "pom.xml", "settings.gradle", "settings.gradle.kts" }) do
            if git and vim.uv.fs_stat(git .. "/" .. marker) then
              return on_dir(git)
            end
          end
          local root = vim.fs.root(bufnr, { "settings.gradle", "settings.gradle.kts", "pom.xml", "build.gradle", "build.gradle.kts" })
          if root then
            on_dir(root)
          end
        end,
        -- gd в библиотеку без исходников отдаёт jar:///…!/….class (jrt:/ для JDK): такой буфер nvim сам
        -- не прочитает, текст класса даёт команда сервера decompile (kotlin-lsp#44). Подсветка через
        -- treesitter без filetype, чтобы к буферу не цеплялись серверы по filetype (jdtls на java).
        on_attach = function(client)
          vim.api.nvim_create_autocmd("BufReadCmd", {
            group = vim.api.nvim_create_augroup("kotlin_lsp_decompile", { clear = true }),
            pattern = { "jar:/*", "jrt:/*" },
            callback = function(ev)
              local res = client:request_sync("workspace/executeCommand", { command = "decompile", arguments = { ev.match } }, 10000, ev.buf)
              local result = res and res.result
              if not (result and type(result.code) == "string") then
                vim.notify("kotlin-lsp: не удалось декомпилировать " .. ev.match, vim.log.levels.WARN)
                return
              end
              vim.api.nvim_buf_set_lines(ev.buf, 0, -1, false, vim.split(result.code, "\n"))
              vim.bo[ev.buf].modified = false
              vim.bo[ev.buf].modifiable = false
              pcall(vim.treesitter.start, ev.buf, result.language)
            end,
          })
        end,
      },
      -- Сервер из extra lang.kotlin: корень у него — ближайший Maven-модуль, gd в соседний не попадает.
      kotlin_language_server = { enabled = false },
    },
  },
}
