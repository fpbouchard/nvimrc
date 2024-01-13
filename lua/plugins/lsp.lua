return {
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
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
      eslint = {},
      prismals = {},
      tsserver = {},
      lua_ls = {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            -- NOTE: toggle below to use Lua_LS's built-in formatter, or use null-ls
            format = { enable = false },
            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            diagnostics = { disable = { "missing-fields" } },
          },
        },
      },
      rust_analyzer = {
        settings = {
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
      },
      yamlls = {
        settings = {
          yaml = {
            keyOrdering = false,
            format = {
              singleQuote = true,
            },
          },
        },
      },
      gopls = {},
      arduino_language_server = {
        cmd = {
          "arduino-language-server",
          "-cli-config",
          "/Users/fp/Library/Arduino15/arduino-cli.yaml",
          "-fqbn",
          "arduino:avr:uno",
        },
      },
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
        mason_servers[server_name].on_attach = on_attach
        mason_servers[server_name].capabilities = capabilities
        require("lspconfig")[server_name].setup(mason_servers[server_name])
      end,
    })
  end,
}
