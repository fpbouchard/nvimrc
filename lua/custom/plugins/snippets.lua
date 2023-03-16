return {
  {
    'rafamadriz/friendly-snippets',
    dependencies = { 'L3MON4D3/LuaSnip' },
    config = function()
      local luasnip = require 'luasnip'
      local from_vscode = require 'luasnip.loaders.from_vscode'

      from_vscode.load({ paths = { "./snippets" } }) -- load locally

      -- activate optional frameworks
      -- https://github.com/rafamadriz/friendly-snippets/tree/main/snippets/frameworks
      luasnip.filetype_extend("dart", { "flutter" })
    end
  }
}
