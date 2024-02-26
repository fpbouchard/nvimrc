return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "mfussenegger/nvim-dap" },
  opts = {
    options = {
      theme = "everforest",
    },
    sections = {
      lualine_b = {
        {
          "diff",
          source = function()
            -- since gitsigns already does this, we can just use its cached values
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
        "diagnostics",
      },
      lualine_c = {
        {
          "filename",
          path = 1,
        },
      },
      lualine_x = {
        {
          function()
            return "  " .. require("dap").status()
          end,
          cond = function()
            return package.loaded["dap"] and require("dap").status() ~= ""
          end,
        },
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          color = { fg = "#ff9e64" },
        },
        { "filetype" },
      },
      lualine_y = {},
    },
  },
}
