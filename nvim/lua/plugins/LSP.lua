return {
	{
		"mason-org/mason.nvim",
		lazy = false,
		priority = 300,
		config = function()
			require("mason").setup(
				{
					-- install_root_dir = "K:/NeoVim/mason",
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗"
						}
					}
				}
			)
		end,
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

			require("mason-lspconfig").setup(
				{
					ensure_installed = {
						"ts_ls",
						-- "lua_ls",
						-- "clangd"
					},
					automatic_installation = true,
					handlers = {
						function(server_name)
							lspconfig[server_name].setup(
								{
									on_attach = on_attach,
									capabilities = cmp_nvim_lsp.default_capabilities(),
									flags = {
										debounce_text_changes = 150
									}
								}
							)
						end
					}
				}
			)

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then return end
					if client.supports_method('textDocument/formatting') then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = args.buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
							end,
						})
					end
				end
			})
		end,
	},

	{
		'saghen/blink.cmp',
		dependencies = { 'rafamadriz/friendly-snippets' },
		version = '1.*',
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = 'default' },
			appearance = {
				nerd_font_variant = 'mono'
			},
			completion = { documentation = { auto_show = false } },
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" }
		},
		opts_extend = { "sources.default" }
	},

	{
		"henriklovhaug/Preview.nvim",
		cmd = { "Preview" },
		config = function()
			require("preview").setup()
		end,
	},
}
