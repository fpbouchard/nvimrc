-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
local on_attach = require("./lsp_config").on_attach
--
-- Flutter .arb files should be considered as json files
vim.filetype.add({
	extension = {
		arb = "json",
	},
})

return {
	{
		"akinsho/flutter-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			require("flutter-tools").setup({
				flutter_lookup_cmd = "asdf where flutter",
				lsp = {
					color = {
						enabled = true,
					},
					on_attach = on_attach,
					capabilities = capabilities,
					settings = {
						completeFunctionCalls = true,
						analysisExcludedFolders = {
							".dart_tool/**",
							vim.fn.expand("$HOME/.pub-cache"),
							"build/**",
							"ios/**",
							"android/**",
						},
						lineLength = 120,
					},
				},
				debugger = {
					enabled = true,
					run_via_dap = true,
					exception_breakpoints = {},
				},
				widget_guides = {
					enabled = true,
				},
			})
			require("telescope").load_extension("flutter")
		end,
	},
}
