return {
  "tpope/vim-fugitive",
  {
    "FabijanZulj/blame.nvim",
    dependencies = {
      "folke/which-key.nvim",
    },
    config = function()
      local wk = require("which-key")
      wk.register({
        t = {
          name = "Toggle",
          b = { "<cmd>ToggleBlame<CR>", "[T]oggle [B]lame", mode = { "n" } },
        },
      }, {
        prefix = "<leader>",
        mode = "n",
      })
    end,
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
