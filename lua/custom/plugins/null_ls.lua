return {
  "jay-babu/mason-null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "nvimtools/none-ls.nvim",
  },
  config = function()
    -- Utility null-ls servers (prettier, eslint, etc)
    local null_ls = require("null-ls")
    local on_attach = require("./lsp_on_attach").on_attach

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,

        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.formatting.eslint_d,
        null_ls.builtins.code_actions.eslint_d,

        null_ls.builtins.formatting.prettierd,

        null_ls.builtins.diagnostics.actionlint,

        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.code_actions.shellcheck,

        null_ls.builtins.diagnostics.terraform_validate,
        null_ls.builtins.formatting.terraform_fmt,

        null_ls.builtins.diagnostics.golangci_lint,
        null_ls.builtins.formatting.goimports_reviser,

        null_ls.builtins.formatting.google_java_format,
      },
      -- temp_dir = vim.fn.stdpath("cache") .. "/null-ls",
      on_attach = on_attach,
    })

    -- Setup mason-null-ls
    require("mason-null-ls").setup({
      ensure_installed = {},
      automatic_installation = true,
      automatic_setup = false,
    })
  end,
}
