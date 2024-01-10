return {
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
}
