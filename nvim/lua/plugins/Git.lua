return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					-- Navigation: Jump between changes
					vim.keymap.set("n", "]h", function()
						gs.nav_hunk("next")
					end, { desc = "Next Hunk" })
					vim.keymap.set("n", "[h", function()
						gs.nav_hunk("prev")
					end, { desc = "Prev Hunk" })

					-- Actions: The "Review" workflow
					vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
					vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Revert this block" })
					vim.keymap.set("n", "<leader>gs", gs.stage_hunk, { desc = "Stage (Add) this block" })
				end,
			})
		end,
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"isakbm/gitgraph.nvim",
		dependencies = { "sindrets/diffview.nvim" },
		opts = {
			git_cmd = "git",
			format = {
				timestamp = "%H:%M:%S %d-%m-%Y",
				fields = { "hash", "timestamp", "author", "branch_name", "tag" },
			},
			symbols = {
				merge_commit = "",
				commit = "",
				merge_commit_end = "",
				commit_end = "",
				GVER = "│",
				GHOR = "─",
				GCLD = "╮",
				GCRD = "╭",
				GCLU = "╯",
				GCRU = "╰",
				GLRU = "┴",
				GLRD = "┬",
				GLUD = "┤",
				GRUD = "├",
				GFORKU = "┼",
				GFORKD = "┼",
				GRUDCD = "├",
				GRUDCU = "├",
				GLUDCD = "┤",
				GLUDCU = "┤",
				GLRDCL = "┬",
				GLRDCR = "┬",
				GLRUCL = "┴",
				GLRUCR = "┴",
			},
			hooks = {
				-- Check diff of a commit
				on_select_commit = function(commit)
					vim.notify("DiffviewOpen " .. commit.hash .. "^!")
					vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
				end,
				-- Check diff from commit a -> commit b
				on_select_range_commit = function(from, to)
					vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
					vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
				end,
			},
		},
		keys = {
			{
				"<leader>gg",
				function()
					require("gitgraph").draw({}, { all = true, max_count = 5000 })
				end,
				desc = "GitGraph - Draw",
			},
		},
	},

	{
		"sindrets/diffview.nvim",
		config = function()
			local actions = require("diffview.actions")
			require("diffview").setup({
				keymaps = {
					view = {
						{ "n", "<leader>r", "do", { desc = "Revert hunk (obtain)" } },
						{ "n", "<leader>s", "dp", { desc = "Stage hunk (put)" } },
						{ "n", "<leader>u", "do", { desc = "Unstage hunk (obtain)" } },
						{ "n", "<leader>q", "<Cmd>DiffviewClose<CR>", { desc = "Close diff" } },
						{ "n", "<leader>f", actions.toggle_files, { desc = "Toggle file panel" } },
					},
					file_panel = {
						{ "n", "<leader>s", actions.toggle_stage_entry, { desc = "Stage file" } },
						{ "n", "<leader>u", actions.unstage_all, { desc = "Unstage all" } },
						{ "n", "<leader>q", "<Cmd>DiffviewClose<CR>", { desc = "Close diff" } },
						{ "n", "<leader>u", actions.restore_entry, { desc = "Restore/Revert file" } },
					},
					file_history_panel = {
						{ "n", "r", actions.refresh_files, { desc = "Refresh file history" } },
						{ "n", "f", actions.toggle_files, { desc = "Toggle file panel" } },
						{ "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diff view" } },
					},
				},
			})
		end,
	},
}
