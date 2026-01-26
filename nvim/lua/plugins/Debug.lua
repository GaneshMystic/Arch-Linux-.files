return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"jay-babu/mason-nvim-dap.nvim",
			"leoluz/nvim-dap-go",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("mason-nvim-dap").setup({
				ensure_installed = { "codelldb", "delve" },
			})

			dapui.setup()
			require("dap-go").setup()

			dap.listeners.before.attach.dapui_config = function() dapui.open() end
			dap.listeners.before.launch.dapui_config = function() dapui.open() end
			dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
			dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

			local mason_path = vim.fn.stdpath("data") .. "/mason/bin/"
			dap.adapters.codelldb = {
				type = "executable",
				command = mason_path .. "codelldb",
			}

			dap.configurations.cpp = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function() return vim.fn.getcwd() .. "/build/my_project" end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			local map = vim.keymap.set
			map("n", "<leader>db", ":DapToggleBreakpoint<CR>", { desc = "Breakpoint" })
			map("n", "<leader>dr", ":DapContinue<CR>", { desc = "Debug/Continue" })
		end,
	},
}

