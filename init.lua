-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Git related plugins
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim", opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing
      "folke/neodev.nvim",
    },
  },

  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "hrsh7th/cmp-buffer" },
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "f-person/git-blame.nvim" },
    config = function()
      -- Set lualine as statusline
      -- See `:help lualine.txt`
      vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
      local git_blame = require("gitblame")
      require("lualine").setup({
        options = {
          theme = "auto",
        },
        sections = {
          lualine_b = {
            "diff",
            "diagnostics",
          },
          lualine_c = {
            {
              "filename",
              path = 1,
              shorting_target = 40,
            },
            { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
          },
          lualine_x = {
            "filetype",
          },
          lualine_y = {},
        },
      })
    end,
  },

  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "┊",
      },
      scope = {
        char = "┃",
        show_start = false,
        show_end = false,
      },
      exclude = { filetypes = { "dashboard" } },
    },
  },

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim",  opts = {} },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    -- commit = "33eb472", -- until https://github.com/nvim-treesitter/nvim-treesitter/issues/4945 is fixed
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
  },

  { import = "custom.plugins" },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- FP: General settings
vim.o.clipboard = "unnamed,unnamedplus" -- connect to system clipboard
vim.o.colorcolumn = "120"
vim.o.cursorline = true
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99 -- do not fold by default
vim.o.foldmethod = "expr"
-- vim.o.nofoldenable = true
vim.o.guicursor =
"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
vim.o.list = true
vim.o.listchars = "tab:>-,trail:·,extends:>,precedes:<,nbsp:+"
vim.o.scrolloff = 3
vim.o.swapfile = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.timeoutlen = 500
vim.o.title = true
vim.o.undolevels = 5000
vim.o.visualbell = true
vim.o.wrap = false

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, {
  command = "silent! checktime",
  pattern = "*",
})

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.shiftround = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- LSP settings.

-- needs to be setup before lsp
require("neodev").setup()

-- Official language servers
local mason_servers = {
  prismals = {},
  tsserver = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
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
local on_attach = require("./lsp_config").on_attach

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

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
  -- Add languages to be installed here that you want installed for treesitter
  -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
  ensure_installed = {
    -- "dart",
    "go",
    "help",
    "java",
    "lua",
    "prisma",
    "python",
    "rust",
    "typescript",
    "vim",
  },
  auto_install = true,
  ignore_install = { "dart" }, -- until this is fixed https://github.com/nvim-treesitter/nvim-treesitter/issues/4945
  highlight = { enable = true },
  indent = { enable = true, disable = { "python" } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = "<c-s>",
      node_decremental = "<c-backspace>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Setup neovim lua configuration

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")
local from_vscode = require("luasnip.loaders.from_vscode")

from_vscode.lazy_load() -- load plugins

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete({}),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
  },
})

-- FP: Other plugins and keymaps

-- In visual mode, shift-J / shift-k moves and indents the selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Paste over selection and bypass black hole register
vim.keymap.set("x", "<leader>p", [["_dP]])
-- Same with delete
vim.keymap.set("n", "<leader>d", [["_d]])

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
