-- The base the branch's MR goes into, by the `mr` skill's rule: the version suffix of the branch name
-- (`<ID>-1-31-11` -> origin/1.31.11-patch, `<ID>-1.4.23` -> origin/1.4.23-patch) when that branch exists, else the
-- line it is nearest to by commits among origin/HEAD, the patch branches and the customer lines dev-*.
-- No ancestor filter: a patch line that moved on after the branch was cut is still its base.
local function mr_base()
  local function git(args)
    local out = vim.fn.systemlist(vim.list_extend({ "git" }, args))
    return vim.v.shell_error == 0 and out or nil
  end
  local branch = (git({ "rev-parse", "--abbrev-ref", "HEAD" }) or {})[1] or ""
  local a, b, c = branch:match("%-(%d+)[%.%-](%d+)[%.%-](%d+)$")
  if a then
    local ref = ("origin/%s.%s.%s-patch"):format(a, b, c)
    if git({ "rev-parse", "-q", "--verify", "refs/remotes/" .. ref }) then
      return ref
    end
  end
  local best, best_n = "origin/HEAD", math.huge
  local refs = git({ "for-each-ref", "--format=%(refname:short)", "refs/remotes/origin" }) or {}
  table.insert(refs, 1, "origin/HEAD")
  for _, ref in ipairs(refs) do
    if ref == "origin/HEAD" or ref:match("%-patch$") or ref:match("/dev%-[^/]+$") then
      local n = tonumber((git({ "rev-list", "--count", ref .. "..HEAD" }) or {})[1])
      if n and n < best_n then
        best, best_n = ref, n
      end
    end
  end
  return best
end

-- <CR>/<BS> in the diff windows: the next/previous change, and past the last (first) change of a file the first
-- change of the next file (the last change of the previous one), like F7/Shift+F7 in IDEA.
local function is_change(lnum)
  return vim.fn.diff_hlID(lnum, 1) ~= 0 or vim.fn.diff_filler(lnum) > 0
end

local function first_change()
  vim.cmd("normal! gg")
  if not is_change(1) then
    pcall(vim.cmd, "normal! ]c")
  end
end

local function last_change()
  first_change()
  while true do
    local before = vim.fn.line(".")
    pcall(vim.cmd, "normal! ]c")
    if vim.fn.line(".") == before then
      return
    end
  end
end

-- the change lands mid-screen, not at its top or bottom edge
local function jump_change(dir)
  return function()
    local before = vim.fn.line(".")
    pcall(vim.cmd, "normal! " .. (dir > 0 and "]c" or "[c"))
    if vim.fn.line(".") ~= before then
      vim.cmd("normal! zz")
      return
    end
    local view = require("diffview.lib").get_current_view()
    -- DiffView has next_file/prev_file, FileHistoryView next_item/prev_item
    local switch = view and (dir > 0 and (view.next_file or view.next_item) or (view.prev_file or view.prev_item))
    if not switch then
      return
    end
    local win = vim.api.nvim_get_current_win()
    local land
    land = function()
      view.emitter:off(land, "file_open_post")
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_call(win, function()
            if dir > 0 then
              first_change()
            else
              last_change()
            end
            vim.cmd("normal! zz")
          end)
        end
      end)
    end
    view.emitter:once("file_open_post", land)
    if not switch(view) then
      view.emitter:off(land, "file_open_post")
    end
  end
end

return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      -- worktree vs HEAD in one diff (IDEA-style), not worktree vs index
      { "<leader>gv", "<cmd>DiffviewOpen HEAD<cr>", desc = "Diffview vs HEAD" },
      -- the branch since it left its MR base: what its MR shows (committed changes only)
      {
        "<leader>gV",
        function()
          local base = mr_base()
          vim.notify("Diffview: " .. base .. "...HEAD")
          vim.cmd("DiffviewOpen " .. base .. "...HEAD")
        end,
        desc = "Diffview branch vs its MR base",
      },
    },
    -- a panel dragged wider by the mouse squeezes only the diff next to it: level the two diffs again
    -- (the panel keeps its width, diffview marks it winfixwidth)
    init = function()
      vim.api.nvim_create_autocmd("WinResized", {
        group = vim.api.nvim_create_augroup("diffview_level_diffs", { clear = true }),
        callback = function()
          for _, win in ipairs(vim.v.event.windows) do
            if vim.api.nvim_win_is_valid(win) and vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "DiffviewFiles" then
              vim.cmd("wincmd =")
              return
            end
          end
        end,
      })
    end,
    opts = {
      file_panel = {
        win_config = { width = 50 },
      },
      keymaps = {
        view = {
          { "n", "<cr>", jump_change(1), { desc = "Next change, past the last one the next file" } },
          { "n", "<bs>", jump_change(-1), { desc = "Previous change, past the first one the previous file" } },
        },
      },
      hooks = {
        diff_buf_win_enter = function(_, winid)
          vim.wo[winid].wrap = true
          -- the whole file unfolded, as after zR; zM still folds the unchanged lines
          vim.wo[winid].foldlevel = 99
        end,
      },
    },
  },
}
