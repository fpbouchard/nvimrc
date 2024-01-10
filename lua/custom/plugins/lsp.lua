return {
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "jay-babu/mason-null-ls.nvim",
    "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp

    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { "j-hui/fidget.nvim", opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- Official language servers, not installed via null-ls
    local mason_servers = {
      prismals = {},
      tsserver = {},
      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          format = { enable = false },
          -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          diagnostics = { disable = { "missing-fields" } },
        },
      },
      rust_analyzer = {
        analyzer = {
          check = {
            command = "clippy",
          },
        },
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
        procMacro = {
          enable = true,
        },
      },
      yamlls = {
        yaml = {
          keyOrdering = false,
          format = {
            singleQuote = true,
          },
        },
      },
      gopls = {},
      arduino_language_server = {},
    }

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    -- Setup mason so it can manage external tooling
    require("mason").setup()

    local mason_lspconfig = require("mason-lspconfig")
    local on_attach = require("./lsp_on_attach").on_attach

    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(mason_servers),
    })

    mason_lspconfig.setup_handlers({
      function(server_name)
        -- vim.pretty_print({ handler = "mason_lspconfig", server_name = server_name })
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = mason_servers[server_name],
        })
      end,
    })

    -- Arduino Language Server
    local fqbn = "arduino:avr:uno"
    local lspconfig = require("lspconfig")
    lspconfig.arduino_language_server.setup({
      cmd = {
        "arduino-language-server",
        "-cli-config",
        "/Users/fp/Library/Arduino15/arduino-cli.yaml",
        "-fqbn",
        fqbn,
      },

      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
}
