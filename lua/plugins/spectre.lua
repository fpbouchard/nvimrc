-- Global search/replace
return {
  'windwp/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('spectre').setup({ live_update = true });
    vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").open()<CR>')
    vim.keymap.set('n', '<leader>rw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>')
    vim.keymap.set('x', '<leader>r', '<cmd>lua require("spectre").open_visual()<CR>')
  end
}
