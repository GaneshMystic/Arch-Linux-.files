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
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
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
		"seblyng/roslyn.nvim",
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		opts = {
			-- "auto" | "roslyn" | "off"
			--
			-- - "auto": Does nothing for filewatching, leaving everything as default
			-- - "roslyn": Turns off neovim filewatching which will make roslyn do the filewatching
			-- - "off": Hack to turn off all filewatching. (Can be used if you notice performance issues)
			filewatching = "auto",

			-- Optional function that takes an array of targets as the only argument. Return the target you
			-- want to use. If it returns `nil`, then it falls back to guessing the target like normal
			-- Example:
			--
			-- choose_target = function(target)
			--     return vim.iter(target):find(function(item)
			--         if string.match(item, "Foo.sln") then
			--             return item
			--         end
			--     end)
			-- end
			choose_target = nil,

			-- Optional function that takes the selected target as the only argument.
			-- Returns a boolean of whether it should be ignored to attach to or not
			--
			-- I am for example using this to disable a solution with a lot of .NET Framework code on mac
			-- Example:
			--
			-- ignore_target = function(target)
			--     return string.match(target, "Foo.sln") ~= nil
			-- end
			ignore_target = nil,

			-- Whether or not to look for solution files in the child of the (root).
			-- Set this to true if you have some projects that are not a child of the
			-- directory with the solution file
			broad_search = false,

			-- Whether or not to lock the solution target after the first attach.
			-- This will always attach to the target in `vim.g.roslyn_nvim_selected_solution`.
			-- NOTE: You can use `:Roslyn target` to change the target
			lock_target = false,

			-- If the plugin should silence notifications about initialization
			silent = false,
		},
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
