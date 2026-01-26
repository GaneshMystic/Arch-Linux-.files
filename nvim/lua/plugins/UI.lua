return {
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
		},
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local c = require("vscode.colors").get_colors()
			require("vscode").setup({
				transparent = true,
				italic_comments = true,
				underline_links = true,
				disable_nvimtree_bg = true,
				terminal_colors = true,
				color_overrides = {
					vscLineNumber = "#555555",
				},
				group_overrides = {
					Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
				},
			})

			vim.cmd.colorscheme("vscode")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		priority = 999,
		config = function()
			require("lualine").setup({
				options = {
					theme = "vscode",
				},
			})
		end,
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					buffer_close_icon = "󰅖",
					close_icon = "󰅖",
					close_command = "bdelete! %d",
					right_mouse_command = "bdelete! %d",
					indicator = {
						style = "icon",
						icon = " ",
					},
					modified_icon = "●",
					offsets = { { filetype = "NvimTree", text = "EXPLORER", text_align = "center" } },
					left_trunc_marker = "",
					right_trunc_marker = "",
					show_close_icon = false,
					show_tab_indicators = true,
				},
				highlights = {
					fill = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "StatusLineNC" },
					},
					background = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "StatusLine" },
					},
					buffer_visible = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					buffer_selected = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					separator = {
						fg = { attribute = "bg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "StatusLine" },
					},
					separator_selected = {
						fg = { attribute = "fg", highlight = "Special" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					separator_visible = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "StatusLineNC" },
					},
					close_button = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "StatusLine" },
					},
					close_button_selected = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					close_button_visible = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
				},
			})
		end,
	},
	{
		"nvimdev/dashboard-nvim",
		lazy = false,
		priority = 1001,
		config = function()
			require("dashboard").setup({
				theme = "hyper",
				config = {
					header = {
						[[                                                       .                                -]],
						[[   .'         _        .   ':.             | o   '     .-'""'-.       '              .   ]],
						[[    +   ✹   /(_))            '::.   .    - o -       .' () .   '.              ✹      .  ]],
						[[   '.     _/   /│          *   '*          |   +    / .      o   \        +        +     ]],
						[[   .     //   / │        o             +           ; o    _   ()  ;                      ]],
						[[        //   /  │  '              +                ;     (_)      ;       *     |    .   ]],
						[[        /\__/   │              + .       +  * .     \ .        o /             -o-       ]],
						[[        \O_/=-. │         +               .          '.  O  .  .'     '+        |     *  ]],
						[[    _  / || \  ^│  ' +              '                  '-....-'                          ]],
						[[    \\/ ()_) \. │         '     *  .      .  .   '.                                      ]],
						[[     ^^ <__> \()│      '    .     ++             .                    .-'~~~-.           ]],
						[[       //||\\   │         '                   '  .   .       +      .'o  oOOOo`.       o ]],
						[[      //_||_\\  │          .;:;:.     `::`        +            .   :~~~-.oOo   o`.       ]],
						[[     // \||/   /│_ \        ::;:':      /    '         '  *         `. \ ~-.\ oOOo.      ]],
						[[    //   ||  \_\(_)/_/    _ ';:;;'     `      _|_             .       `.$$/ ~.\ OO:     o]],
						[[   \/    |/   _//o\\_     >'. ||  _            |                      .$$$;--━`.o.'      ]],
						[[   /     |     /   \      `> \||.'<                                  ,'$$; ~~--'~        ]],
						[[  /      |        \         `>|/ <`                                  ;$$;                ]],
						[[_╱_______│___\|/___\_________`||/`________\\/_________\|/__________\\//\\//___\|/________]],
					},
					shortcut = {
						{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
					},
					footer = { "☢️ HI Mystic ☢️" },
				},
			})
		end,
	},
	{
		"folke/which-key.nvim",
		lazy = true,
		event = "VeryLazy",
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	-- autopairing of (){}[] etc
	{
		"windwp/nvim-autopairs",
		opts = {
			fast_wrap = {},
			disable_filetype = { "TelescopePrompt", "vim" },
		},
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		config = function(_, opts)
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowGreen",
				"RainbowOrange",
				"RainbowCyan",
			}

			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			-- vim.g.rainbow_delimiters = { highlight = highlight }
			require("ibl").setup({ indent = { char = "▏" }, scope = { char = "▏", highlight = highlight } })
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = "VeryLazy",
		config = function()
			require("rainbow-delimiters.setup").setup({
				strategy = {
					"nvim-treesitter/nvim-treesitter",
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate | TSInstallAll",
		opts = function()
			return {
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"html",
					"css",
					"javascript",
					"typescript",
					"tsx",
					"python",
					"json",
					"go",
					"gomod",
					"gowork",
					"gosum",
				},
				highlight = {
					enable = true,
					--use_languagetree = true,
				},
				indent = {
					enable = true,
				},
			}
		end,
	},
	{ "nvzone/volt", lazy = true },
	{
		"nvzone/menu",
		config = function()
			local map = vim.keymap.set

			map("n", "<leader>m", function()
				require("menu").open("default")
			end, { desc = "Open Context Menu" })
			map({ "n", "v" }, "<RightMouse>", function()
				require("menu.utils").delete_old_menus()
				vim.cmd.exec('"normal! \\<RightMouse>"')
				local mouse = vim.fn.getmousepos()
				local buf = vim.api.nvim_win_get_buf(mouse.winid)
				local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"
				require("menu").open(options, { mouse = true })
			end, { desc = "Context Menu (Mouse)" })
		end,
	},
}
