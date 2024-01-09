-- Fuzzy Finder (files, lsp, etc)
return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
			"nvim-telescope/telescope-live-grep-args.nvim",
		},
		config = function()
			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			local actions = require("telescope.actions")
			local lga_actions = require("telescope-live-grep-args.actions")
			local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

			require("telescope").setup({

				defaults = {
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-t>"] = false,
						},
					},
					layout_strategy = "flex",
					layout_config = {
						horizontal = { width = 0.95, preview_width = 0.4 },
					},
					scroll_strategy = "limit",
					path_display = { "smart" },
					dynamic_preview_title = true,
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
					buffers = {
						ignore_current_buffer = true,
						sort_mru = true,
						mappings = {
							i = {
								["<c-d>"] = actions.delete_buffer,
							},
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
					file_browser = {
						grouped = true,
						hidden = true,
						respect_gitignore = false,
					},
					live_grep_args = {
						mappings = {
							i = {
								["<C-t>"] = lga_actions.quote_prompt({ postfix = " --iglob !**/test/**" }),
								["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							},
						},
					},
				},
			})

			require("telescope").load_extension("live_grep_args")

			-- See `:help telescope.builtin`
			vim.keymap.set(
				"n",
				"<leader>?",
				require("telescope.builtin").oldfiles,
				{ desc = "[?] Find recently opened files" }
			)
			vim.keymap.set(
				"n",
				"<leader>b",
				require("telescope.builtin").buffers,
				{ desc = "[b] Find existing buffers" }
			)
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer]" })

			vim.keymap.set(
				"n",
				"<leader><leader>",
				require("telescope.builtin").find_files,
				{ desc = "[<leader>] Search Files" }
			)
			vim.keymap.set(
				"n",
				"<leader>sw",
				live_grep_args_shortcuts.grep_word_under_cursor,
				{ desc = "[S]earch current [W]ord" }
			)
			vim.keymap.set(
				"n",
				"<leader>sg",
				require("telescope").extensions.live_grep_args.live_grep_args,
				{ desc = "[S]earch by [G]rep" }
			)
			vim.keymap.set(
				"n",
				"<leader>sf",
				require("telescope").extensions.flutter.commands,
				{ desc = "[S]earch [F]lutter" }
			)
			vim.keymap.set(
				"n",
				"<leader>sp",
				require("telescope").extensions.dap.commands,
				{ desc = "[S]earch DA[P] (Debugger)" }
			)
			vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
		end,
	},
	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
		config = function()
			pcall(require("telescope").load_extension, "fzf")
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			-- open file_browser with the path of the current buffer
			vim.api.nvim_set_keymap(
				"n",
				"-",
				":Telescope file_browser path=%:p:h select_buffer=true<CR>",
				{ noremap = true }
			)

			require("telescope").load_extension("file_browser")
		end,
	},
	{
		"HUAHUAI23/telescope-session.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			vim.api.nvim_set_keymap("n", "<leader>sl", ":Telescope xray23 list<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>ss", ":Telescope xray23 save<CR>", { noremap = true })

			require("telescope").load_extension("xray23")
		end,
	},
}
