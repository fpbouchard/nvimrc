return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      dim_inactive = true,
      on_highlights = function(hl, _)
        hl.Comment = { fg = "#8194b3", style = "italic" }
      end,
    })
    vim.cmd([[colorscheme tokyonight]])
  end,
}
