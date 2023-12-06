return {
	"stevearc/vim-arduino",
	dependencies = { "folke/which-key.nvim" },
	config = function()
		local wk = require("which-key")

		wk.register({
			a = {
				name = "Arduino",
				a = { "<cmd>ArduinoAttach<CR>", "Attach" },
				v = { "<cmd>ArduinoVerify<CR>", "Verify" },
				u = { "<cmd>ArduinoUpload<CR>", "Upload" },
				s = { "<cmd>ArduinoSerial<CR>", "Serial" },
				b = { "<cmd>ArduinoChooseBoard<CR>", "Choose Board" },
				p = { "<cmd>ArduinoChooseProgrammer<CR>", "Choose Programmer" },
				us = { "<cmd>ArduinoUploadAndSerial<CR>", "Upload and Serial" },
			},
		}, { prefix = "<leader>" })
	end,
}
