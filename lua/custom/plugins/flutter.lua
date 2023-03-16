-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
local on_attach = require('./lsp').on_attach

return {
  {
    'akinsho/flutter-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim', },
    config = function()
      require('flutter-tools').setup({
        lsp = {
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            lineLength = 120,
          }
        },
        debugger = {
          enabled = true,
          run_via_dap = true
        },
        widget_guides = {
          enabled = true
        }
      })
      require('telescope').load_extension('flutter')
    end
  }
}
