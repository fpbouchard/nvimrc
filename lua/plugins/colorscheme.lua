return {
  "sainnhe/everforest",
  config = function()
    vim.o.termguicolors = true
    vim.g.everforest_background = "hard"
    vim.g.everforest_better_performance = 1
    vim.cmd.colorscheme("everforest")
  end,
}