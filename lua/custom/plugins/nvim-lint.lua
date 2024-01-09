return {
	"mfussenegger/nvim-lint",
	config = function()
		require("lint").linters_by_ft = {
			yaml = { "actionlint" },
			python = { "flake8" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			sh = { "shellcheck" },
			go = { "golangcilint" },
		}
	end,
	init = function()
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
