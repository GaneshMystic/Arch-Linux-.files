return {
	{
		"mason-org/mason.nvim",
		lazy = false,
		priority = 300,
		opts = {
			ensure_installed = {
				"clangd",
				"ts_ls",
				"clang-format",
				"codelldb",
				"prettier",
				"stylua",
				"black",
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		lazy = false,
		priority = 301,
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			local on_attach = function(client, bufnr)
				cmp_nvim_lsp.default_capabilities()
				null_ls.on_attach(client, bufnr)
			end

			vim.diagnostic.config({
				virtual_text = {
					enabled = true,
					-- Optional: customize the look of the virtual text
					severity = { min = vim.diagnostic.severity.HINT },
					spacing = 4,
					prefix = "•",
				},
				signs = true, -- Show icons in the sign column
				update_in_insert = false, -- Don't constantly update in insert mode
				float = { -- Configuration for the hover/peek window
					border = "rounded",
					source = "always",
				},
			})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"clangd",
					-- "lua_ls",
				},
				automatic_installation = true,
				handlers = {
					function(server_name)
						lspconfig[server_name].setup({
							on_attach = on_attach,
							capabilities = cmp_nvim_lsp.default_capabilities(),
							flags = {
								debounce_text_changes = 150,
							},
						})
					end,
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local map = vim.keymap.set
					if not client then
						return
					end
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = args.buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
							end,
						})
					end

					map("n", "<leader>vd", vim.diagnostic.open_float, { buffer = args.buf, desc = "Diagnostic float" })
					map("n", "[d", vim.diagnostic.goto_prev, { buffer = args.buf, desc = "Previous Diagnostic" })
					map("n", "]d", vim.diagnostic.goto_next, { buffer = args.buf, desc = "Next Diagnostic" })
				end,
			})
		end,
	},

	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		opts = {
			keymap = {
				preset = "enter",
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = { documentation = { auto_show = false } },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},

	{
		"henriklovhaug/Preview.nvim",
		cmd = { "Preview" },
		config = function()
			require("preview").setup()
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup({
				-- Configuration options here
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		config = function()
			-- Example conform.nvim configuration
			require("conform").setup({
				-- This is the core table where you link filetypes to formatters
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black" },
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					json = { "prettier" },
					css = { "prettier" },
					scss = { "prettier" },
					less = { "prettier" },
					html = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					graphql = { "prettier" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					["objc"] = { "clang-format" },
					["objcpp"] = { "clang-format" },
					["cpp.doxygen"] = { "clang-format" },
				},

				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"mason-org/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "codelldb" },
			})
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
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
					program = function()
						-- The path to your compiled C++ executable ==================================================================================
						-- return vim.fn.input("Path to executable ", vim.fn.getcwd() .. "/", "file")
						return vim.fn.getcwd() .. "/build/my_project"
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			local map = vim.keymap.set

			map("n", "<leader>db", ":DapToggleBreakpoint<CR>", { desc = "Add Breakpoint" })
			map("n", "<leader>dr", ":DapContinue<CR>", { desc = "Start or Continue Debugging" })
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"leoluz/nvim-dap-go",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-go").setup()
		end,
	},
}
