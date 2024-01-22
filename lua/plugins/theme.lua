return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    vim.o.termguicolors = true
    vim.o.background = "dark"
    vim.cmd.colorscheme("catppuccin-macchiato")
    require("catppuccin").setup({
      integrations = {
        fidget = true,
        mason = true,
        lsp_trouble = true,
        which_key = true,
      },
    })
  end,
}
