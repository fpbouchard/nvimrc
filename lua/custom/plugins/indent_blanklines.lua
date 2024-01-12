return {
  -- Add indentation guides even on blank lines
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      char = "┊",
    },
    scope = {
      char = "┃",
      show_start = false,
      show_end = false,
    },
    exclude = { filetypes = { "dashboard", "Trouble", "trouble" } },
  },
}
