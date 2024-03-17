return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
          require("copilot").setup({
            suggestion = {
              auto_trigger = true,
            },
          })

          vim.keymap.set("i", "<Tab>", function()
            if require("copilot.suggestion").is_visible() then
              require("copilot.suggestion").accept()
            else
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
            end
          end, { desc = "Super Tab" })
        end,
      },
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {},
  },
}
