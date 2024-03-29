-- Flutter .arb files should be considered as json files
vim.filetype.add({
  extension = {
    arb = "json",
  },
})

return {
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      require("flutter-tools").setup({
        flutter_lookup_cmd = "asdf where flutter",
        lsp = {
          color = {
            enabled = true,
          },
          capabilities = capabilities,
          settings = {
            completeFunctionCalls = true,
            analysisExcludedFolders = {
              ".dart_tool/**",
              vim.fn.expand("$HOME/.pub-cache"),
              "build/**",
              "ios/**",
              "android/**",
            },
            lineLength = 120,
          },
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = {},
        },
        widget_guides = {
          enabled = true,
        },
      })
      require("telescope").load_extension("flutter")
    end,
  },
}
