return {
	{
		"mason-org/mason.nvim",
		lazy = false,
		priority = 300,
		opts = {
			ensure_installed = {
				--"clangd",
				--"clang-format",
				-- "codelldb",
				-- "prettier",
				"stylua",
				"black",
				-- go lang setup
				"gopls",
				"goimports",
				"delve",
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
		opts = {
			ensure_installed = { "gopls", "lua_ls" },
			automatic_enable = true,
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			vim.lsp.config("gopls", {
				settings = {
					gopls = {
						analyses = { unusedparams = true },
						staticcheck = true,
						completeUnimported = true,
						usePlaceholders = true,
					},
				},
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
				kind_icons = {
					Text = "󰉿",
					Method = "󰊕",
					Function = "󰊕",
					Constructor = "",
					Field = "󰜢",
					Variable = "󰀫",
					Class = "󰠱",
					Interface = "",
					Module = "",
					Property = "󰜢",
					Unit = "󰑭",
					Value = "󰎟",
					Enum = "",
					Keyword = "󰌋",
					Snippet = "",
					Color = "󰏘",
					File = "󰈙",
					Reference = "󰬲",
					Folder = "󰉋",
					EnumMember = "",
					Constant = "󰏿",
					Struct = "󰙅",
					Event = "",
					Operator = "󰆕",
					TypeParameter = "󰊄",
				},
			},
			completion = {
				menu = {
					draw = {
						-- This is the "Chad" look: Icon + Label + Kind Name
						columns = { { "kind_icon", "label", gap = 1 }, { "kind" } },
					},
				},
				documentation = { auto_show = false },
			},
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
			-- for markdown preview
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
					go = { "goimports", "gofmt" },
				},

				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
}
