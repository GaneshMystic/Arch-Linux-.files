return {
	{
		"isakbm/gitgraph.nvim",
		lazy = true,
		priority = 500,
		dependencies = { "sindrets/diffview.nvim" },
		config = function()
			require("gitgraph").setup(
				{
					git_cmd = "git",
					format = {
						timestamp = "%H:%M:%S %d-%m-%Y",
						fields = { "hash", "timestamp", "author", "branch_name", "tag" }
					},
					hooks = {
						on_select_commit = function(commit)
							print("selected commit:", commit.hash)
							vim.notify("DiffviewOpen " .. commit.hash .. "^!")
							vim.cmd("DiffviewOpen " .. commit.hash .. "^!")
						end,
						on_select_range_commit = function(from, to)
							print("selected range:", from.hash, to.hash)
							vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
							vim.cmd("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
						end
					}
				}
			)
		end,
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
