-- The lang.markdown extra turns checkbox rendering off (checkbox.enabled = false); this turns it back on
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      checkbox = {
        enabled = true,
      },
    },
  },
}
