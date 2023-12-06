return {

	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			"nvim-telescope/telescope-dap.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local dap = require("dap")
			-- local dapui = require("dapui")

			require("mason-nvim-dap").setup({
				-- Makes a best effort to setup the various debuggers with
				-- reasonable debug configurations
				automatic_setup = true,
				-- You'll need to check that you have the required things installed
				-- online, please don't ask me how to install them :)
				ensure_installed = {
					-- Update this to ensure that you have the debuggers for the langs you want
				},
			})

			-- Basic debugging keymaps, feel free to change to your liking!
			vim.keymap.set("n", "<F5>", dap.continue)
			vim.keymap.set("n", "<F1>", dap.step_into)
			vim.keymap.set("n", "<F2>", dap.step_over)
			vim.keymap.set("n", "<F3>", dap.step_out)
			vim.keymap.set("n", "<leader>B", dap.toggle_breakpoint)
			-- vim.keymap.set("n", "<leader>B", function()
			-- 	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			-- end)
			require("telescope").load_extension("dap")
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		config = function()
			require("dapui").setup()

			vim.keymap.set("n", "<leader>dp", '<cmd>lua require("dapui").toggle()<CR>', { silent = true })
			vim.keymap.set("n", "<leader>i", '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })

			-- dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			-- dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			-- dap.listeners.before.event_exited["dapui_config"] = dapui.close
		end,
	},
}
