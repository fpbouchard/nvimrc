return {
  "jay-babu/mason-null-ls.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "nvimtools/none-ls.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,

        null_ls.builtins.formatting.prettierd,

        null_ls.builtins.formatting.shfmt,
        -- https://github.com/nvimtools/none-ls.nvim/issues/58
        -- null_ls.builtins.diagnostics.shellcheck,
        -- null_ls.builtins.code_actions.shellcheck,
        -- null_ls.builtins.formatting.beautysh,
        null_ls.builtins.hover.printenv,
        null_ls.builtins.diagnostics.zsh,

        null_ls.builtins.diagnostics.terraform_validate,
        null_ls.builtins.formatting.terraform_fmt,

        null_ls.builtins.diagnostics.golangci_lint,
        null_ls.builtins.formatting.goimports_reviser,

        null_ls.builtins.formatting.google_java_format,

        null_ls.builtins.diagnostics.commitlint,

        null_ls.builtins.diagnostics.hadolint, -- Dockerfile

        -- https://github.com/nvimtools/none-ls.nvim/issues/58
        -- null_ls.builtins.diagnostics.jsonlint,

        null_ls.builtins.diagnostics.markdownlint,

        null_ls.builtins.diagnostics.stylelint, -- CSS

        null_ls.builtins.diagnostics.yamllint,

        null_ls.builtins.diagnostics.sqlfluff.with({
          extra_args = { "--dialect", "mysql" },
        }),
        null_ls.builtins.formatting.sqlfluff.with({
          extra_args = { "--dialect", "mysql" },
        }),
      },
      -- temp_dir = vim.fn.stdpath("cache") .. "/null-ls",
    })

    -- Setup mason-null-ls
    require("mason-null-ls").setup({
      ensure_installed = {},
      automatic_installation = true,
      automatic_setup = false,
    })
  end,
}
