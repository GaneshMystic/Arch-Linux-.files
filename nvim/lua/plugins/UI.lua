return {
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local c = require("vscode.colors").get_colors()
			require("vscode").setup(
				{
					transparent = true,
					italic_comments = true,
					underline_links = true,
					disable_nvimtree_bg = true,
					terminal_colors = true,
					color_overrides = {
						vscLineNumber = "#FFFFFF"
					},
					group_overrides = {
						Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true }
					}
				}
			)

			vim.cmd.colorscheme("vscode")
			vim.o.background = "dark"       -- or 'light'
		end
	},
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		priority = 999,
		config = function()
			require("lualine").setup()
		end
	},
	{
		"nvimdev/dashboard-nvim",
		lazy = false,
		priority = 1001,
		config = function()
			require("dashboard").setup(
				{
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
							[[_╱_______│___\|/___\_________`||/`________\\/_________\|/__________\\//\\//___\|/________]]
						},
						shortcut = {
							{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" }
						},
						footer = { "☢️ HI Mystic ☢️" }
					}
				}
			)
		end
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
	}
	-- {
	--     "nvzone/volt",
	--     lazy = true
	-- },
	-- {
	--     "nvzone/minty",
	--     cmd = { "Shades", "Huefy" },
	-- }
}
