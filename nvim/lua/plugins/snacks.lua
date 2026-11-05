return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Плавная прокрутка вдвое быстрее штатной (у snacks step = 10/5, total = 200/50 мс)
      scroll = {
        enabled = true,
        animate = { duration = { step = 5, total = 100 } },
        animate_repeat = { duration = { step = 2.5, total = 25 } },
      },
    },
  },
}
