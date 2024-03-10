return {
  "junegunn/vim-easy-align",
  config = function()
    vim.cmd [[
      xmap ga <Plug>(EasyAlign)
      nmap ga <Plug>(EasyAlign)
    ]]
  end,
}
