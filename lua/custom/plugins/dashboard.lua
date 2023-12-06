return {
	"glepnir/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
			config = {
				week_header = {
					enable = true,
				},
			},
			-- config
		})
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
