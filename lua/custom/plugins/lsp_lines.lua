return {
	"ErichDonGubler/lsp_lines.nvim",
	config = function()
		require("lsp_lines").setup()
		vim.diagnostic.config({
			virtual_lines = false,
		})
		vim.keymap.set("", "L", require("lsp_lines").toggle, { desc = "Toggle [L]SP Lines" })
	end,
}
