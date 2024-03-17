-- copied and adapted from LazyVim: https://www.lazyvim.org/plugins/ui#dashboard-nvim
return {
  "nvimdev/dashboard-nvim",
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
  event = "VimEnter",
  config = function()
    local logo = {
      [[    ╔╓        W                                                                    ]],
      [[  ╗╣╬╠D       ╣╣▒_                                            ▄▄                   ]],
      [[j╩╫╫╫╠╠╠,     ╣╣╣╣▒                                           ▀▀                   ]],
      [[╠▒▒╢╫╠╠╠╠W    ╣╣╣╣╣     |⌐╓ªªMW_   ▄M"ª%╓   ▄KFF¥▄ ╙█▓    ▐█▌ ▓▓  █▓▄▓██▌╓▓▓██▌_   ]],
      [[╠╠╠╠╠╙╢╢╢╢╢.  ╣▓▓▓▓     ▐▌     █  ▌     '▄ ▓      ▓ ╫█▓  ╒██  ██⌐ ██M  ▐██   ╫██   ]],
      [[╠╠╠╠╠ `╢╬╬╬╬φ ╣▓▓▓▓     ▐▌     ▓ ▐▌└└└└└└`▐▌      ╫▌ ╫█▌ ██   ██⌐ ██⌐  ▐██   ▐██   ]],
      [[╠╢╢╢╢   ╙╬╬╬╬╣▓▓▓▓▓     ▐▌     ▓  ▓        ▓      ▓   ▓█▓█"   ██⌐ ██⌐  ▐██   ▐██   ]],
      [[╠╬╬╬╬    '╣╫╫╫▓▓▓▓▓     └L     ▀   ╙▀≡mM╙   ╙¥∞═M╙     ▀▀"    ▀▀  ▀▀   '▀▀   ╘▀▀   ]],
      [[└╣╬╬╬      ╚╫╫▓▓▓▓▀                                                                ]],
      [[  '╢╫       └╣▓▓╨                                                                  ]],
      [[    '         "                                                                    ]],
    }
    local opts = {
      theme = "hyper",
      config = {
        header = logo,
        shortcut = {
          {
            action = "Telescope find_files",
            desc = " Find file",
            key = "f",
            group = "DiagnosticInfo",
          },
          {
            action = "Telescope oldfiles",
            desc = " Recent files",
            key = "r",
            group = "Conditional",
          },
          {
            action = "Lazy",
            desc = "󰒲 Lazy",
            key = "l",
            group = "DiagnosticOk",
          },
          {
            action = "Mason",
            desc = "󰣪 Mason",
            key = "m",
            group = "DiagnosticError",
          },
          {
            action = "qa",
            desc = " Quit",
            key = "q",
            group = "Comment",
          },
        },
        project = { enable = false },
        mru = { limit = 20, cwd_only = true },
        footer = {},
      },
    }

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "DashboardLoaded",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    -- Set DashboardHeader guifg to the neovim logo color
    -- hi DashboardHeader guifg='neovim logo color'
    vim.cmd("hi DashboardHeader guifg=#3E93D3")

    require("dashboard").setup(opts)

    vim.keymap.set("n", "<leader>dd", ":Dashboard<CR>")
  end,
}
