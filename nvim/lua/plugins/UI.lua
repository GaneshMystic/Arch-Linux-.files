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
					vscLineNumber = "#FFFFFF",
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
			require("lualine").setup()
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
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
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
				-- Optional: Configure the strategy and queries if needed
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
		build = ":TSUpdate",
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
				},
				highlight = {
					enable = true, -- Must be enabled for IBL to work correctly
					use_languagetree = true,
				},
				indent = {
					enable = true, -- Must be enabled for IBL to work correctly
				},
			}
		end,
	},
}
