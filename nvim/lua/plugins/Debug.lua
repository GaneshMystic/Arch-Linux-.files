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
			dap.adapters.go = {
				type = "executable",
				command = "dlv",
				args = { "dap" },
			}
			local dapui = require("dapui")

			require("mason-nvim-dap").setup({
				ensure_installed = { "delve" },
				automatic_installation = true,
			})

			dapui.setup()

			require("dap-go").setup({
				dap_configurations = {
					{
						type = "go",
						name = "Debug Project (Main)",
						request = "launch",
						program = "${fileDirname}",
					},
					{
						type = "go",
						name = "Attach remote",
						mode = "remote",
						request = "attach",
					},
				},
				delve = {
					path = "dlv",
					initialize_timeout_sec = 20,
					port = "${port}",
					args = {},
					build_flags = {},
					detached = vim.fn.has("win32") == 0,
					cwd = nil,
				},
			})

			-- Breakpoint Styles
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })

			-- UI Listeners
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			local map = vim.keymap.set

			-- Keybindings
			map("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
			map("n", "<leader>dc", dap.continue, { desc = "Debug: Start/Continue" })
			map("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
			map("n", "<leader>dO", dap.step_over, { desc = "Debug: Step Over" })
			map("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
			map("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
			map("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
			map("n", "<leader>do", dap.step_out, { desc = "Debug: Step Out" })
			map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			map("n", "<leader>dq", dap.terminate, { desc = "Debug: Terminate" })
			map("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
			map("n", "<leader>dt", function()
				require("dap-go").debug_test()
			end, { desc = "Debug: Go Test" })
		end,
	},
}
