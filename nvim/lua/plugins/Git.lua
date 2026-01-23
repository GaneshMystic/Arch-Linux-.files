return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require('gitsigns').setup()
		end
	},
	{
		'isakbm/gitgraph.nvim',
		opts = {
			git_cmd = "git",
			format = {
				timestamp = '%H:%M:%S %d-%m-%Y',
				fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
			},
			hooks = {
				-- Check diff of a commit
				on_select_commit = function(commit)
					vim.notify('DiffviewOpen ' .. commit.hash .. '^!')
					vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
				end,
				-- Check diff from commit a -> commit b
				on_select_range_commit = function(from, to)
					vim.notify('DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
					vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
				end,
			},
		},
		keys = {
			{
				"<leader>gl",
				function()
					require('gitgraph').draw({}, { all = true, max_count = 5000 })
				end,
				desc = "GitGraph - Draw",
			},
		},
	},

	{
		"sindrets/diffview.nvim",
		config = function()
			local actions = require("diffview.actions")
			require("diffview").setup(
				{
					keymaps = {
						view = {
							{ "n", "r",  actions.refresh_files,    { desc = "Refresh diff view" } },
							{ "n", "f",  actions.toggle_files,     { desc = "Toggle file panel" } },
							{ "n", "ff", actions.focus_files,      { desc = "Focus file panel" } },
							{ "n", "x",  "<Cmd>DiffviewClose<CR>", { desc = "Close diff view" } }
						},
						file_panel = {
							{ "n", "r", actions.refresh_files,    { desc = "Refresh file panel" } },
							{ "n", "f", actions.toggle_files,     { desc = "Toggle file panel" } },
							{ "n", "x", "<Cmd>DiffviewClose<CR>", { desc = "Close diff view" } }
						},
						file_history_panel = {
							{ "n", "r", actions.refresh_files,    { desc = "Refresh file history" } },
							{ "n", "f", actions.toggle_files,     { desc = "Toggle file panel" } },
							{ "n", "x", "<Cmd>DiffviewClose<CR>", { desc = "Close diff view" } }
						}
					}
				}
			)
			vim.keymap.set("n", "<leader>diff", ":DiffviewOpen<CR>", { desc = "Open Git diff view" })
		end,
	},
}
