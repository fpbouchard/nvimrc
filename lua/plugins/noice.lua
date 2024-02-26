return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    cmdline = { enabled = false },
    messages = { enabled = false },
    popupmenu = { enabled = false },
    notify = { enabled = false },
    lsp = {
      progress = { enabled = false },
      message = { enabled = false },
    },
    smart_move = { enabled = false },
    presets = {
      lsp_doc_border = true,
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
  },
}
