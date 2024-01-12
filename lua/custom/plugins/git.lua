return {
  "tpope/vim-fugitive",
  {
    "FabijanZulj/blame.nvim",
    opts = {},
    keys = {
      { "<leader>tb", "<cmd>ToggleBlame virtual<CR>", desc = "[T]oggle [B]lame" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
}
