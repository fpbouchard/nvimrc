-- copied and adapted from LazyVim: https://www.lazyvim.org/plugins/ui#dashboard-nvim
return {
  "nvimdev/dashboard-nvim",
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
  event = "VimEnter",
  opts = function()
    local logo = [[
      ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
      ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
      ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
      ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
      ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
      ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
    ]]
    logo = string.rep("\n", 8) .. logo .. "\n\n"
    local opts = {
      theme = "hyper",
      config = {
        header = vim.split(logo, "\n"),
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
        mru = { limit = 20 },
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

    return opts
  end,
}
