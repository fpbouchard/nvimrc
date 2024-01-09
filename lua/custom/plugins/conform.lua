return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { { "prettierd", "prettier" }, "eslint_d" },
			typescript = { { "prettierd", "prettier" }, "eslint_d" },
			typescriptreact = { { "prettierd", "prettier" }, "eslint_d" },
			javascriptreact = { { "prettierd", "prettier" }, "eslint_d" },
			sh = { "shfmt" },
			terraform = { "terraform_fmt" },
			go = { "goimports-reviser" },
			java = { "google-java-format" },
		},
		format_on_save = {
			timeout_ms = 5000,
			lsp_fallback = true,
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
