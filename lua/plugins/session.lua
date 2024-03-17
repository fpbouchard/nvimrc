return {
  "olimorris/persisted.nvim",
  lazy = false, -- make sure the plugin is always loaded at startup
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("persisted").setup({
      should_autosave = function()
        -- do not autosave if the dashboard.nvim is the current filetype
        if vim.bo.filetype == "dashboard" then
          return false
        end
        return true
      end,
    })
    require("telescope").load_extension("persisted")

    vim.api.nvim_set_keymap("n", "<leader>ss", ":Telescope persisted<CR>", { noremap = true })
    vim.api.nvim_set_keymap("n", "<leader>qs", ":SessionLoad<CR>", { noremap = true })
  end,
}
