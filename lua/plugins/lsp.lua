local lsp_formatting = function(bufnr)
  -- if the buffer has an eslint client, run eslint --fix
  local util = require("lspconfig.util")
  local eslint_lsp_client = util.get_active_client_by_name(bufnr, "eslint")
  if eslint_lsp_client ~= nil then
    vim.api.nvim_command("EslintFixAll")
  end

  -- If the buffer has null-ls sources, use them for formatting
  local null_ls_sources = require("null-ls.sources")
  local ft = vim.bo[bufnr].filetype
  local has_null_ls = #null_ls_sources.get_available(ft, "NULL_LS_FORMATTING") > 0

  vim.lsp.buf.format({
    bufnr = bufnr,
    filter = function(client)
      if has_null_ls then
        return client.name == "null-ls"
      else
        return client.name ~= "tsserver"
      end
    end,
  })
end

return {
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp

    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { "j-hui/fidget.nvim", opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- Official language servers, not installed via null-ls
    local servers = {
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

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP Specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    -- Setup mason so it can manage external tooling
    require("mason").setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    -- Add servers used by null-ls and other tools that are not necessarily LSPs
    vim.list_extend(ensure_installed, {
      "dart-debug-adapter",
      "goimports-reviser",
      "golangci-lint",
      "google-java-format",
      "gopls",
      "hadolint",
      "jsonlint",
      "markdownlint",
      "node-debug2-adapter",
      "prettierd",
      "shfmt",
      "sqlfluff",
      "stylelint",
      "stylua",
      "yamllint",
    })
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })

    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("OnLspAttach", { clear = true }),
      callback = function(event)
        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end

          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
        end

        local xmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end

          vim.keymap.set("x", keys, func, { buffer = event.buf, desc = desc })
        end

        local imap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end

          vim.keymap.set("i", keys, func, { buffer = event.buf, desc = desc })
        end

        nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        nmap("<C-\\>", vim.lsp.buf.code_action, "[C]ode [A]ction")
        xmap("<C-\\>", vim.lsp.buf.code_action, "[C]ode [A]ction")

        nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        nmap("gi", require("telescope.builtin").lsp_incoming_calls, "[G]oto [i]ncoming calls")
        nmap("go", require("telescope.builtin").lsp_outgoing_calls, "[G]oto [o]utgoing calls")
        nmap("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto Type [D]efinition")
        nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

        -- See `:help K` for why this keymap
        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
        imap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
        nmap("<C-e>", function()
          vim.diagnostic.open_float(nil, { focus = false })
        end, "Open Diagnostic Float")

        -- Lesser used LSP functionality
        nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
        nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
        nmap("<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist Folders")

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(event.buf, "Format", function(_)
          lsp_formatting(event.buf)
        end, { desc = "Format current buffer with LSP" })

        -- Format on save
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client.supports_method("textDocument/formatting") then
          local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = event.buf })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = event.buf,
            callback = function()
              lsp_formatting(event.buf)
            end,
          })
        end
      end,
    })
  end,
}
