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
				timestamp = "| %Y-%m-%d %H:%M:%S |",
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
				on_select_commit = function(commit)
					local gg = require("gitgraph")
					local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
					local current_br = vim.fn.systemlist("git branch --show-current")[1]
					local full_hash = vim.fn.systemlist("git -C " .. git_root .. " rev-parse " .. commit.hash)[1]

					local function run(cmd)
						local output = vim.fn.system("git -C " .. git_root .. " " .. cmd)
						vim.notify(output ~= "" and output or "Action successful")
						gg.draw({}, { all = true, max_count = 1000 })
					end

					local options = { " Diff Split", "󰅍 Copy Hash", " Create New Branch", " Cherry-pick" }

					-- Use the first branch name in the list if it exists
					local target_branch = (commit.branch_names and #commit.branch_names > 0) and commit.branch_names[1]
						or nil

					if target_branch then
						if target_branch ~= current_br then
							table.insert(options, " Checkout Branch: " .. target_branch)
							table.insert(options, " Merge " .. target_branch)
							table.insert(options, "󰆴 Delete Branch: " .. target_branch)
						else
							table.insert(options, "󰑕 Rename Branch")
						end
					end

					vim.ui.select(
						options,
						{ prompt = "Git Action (" .. commit.hash:sub(1, 7) .. "):" },
						function(choice)
							if not choice then
								return
							end

							if choice == " Create New Branch" then
								local name = vim.fn.input("New branch name: ")
								if name ~= "" then
									run("checkout -b " .. name .. " " .. full_hash)
								end
							elseif choice:match("Checkout Branch:") then
								run("checkout " .. target_branch)
							elseif choice:match("Merge") then
								run("merge " .. target_branch)
							elseif choice == " Cherry-pick" then
								run("cherry-pick " .. full_hash)
							elseif choice == " Diff Split" then
								vim.cmd("DiffviewOpen " .. full_hash .. "^!")
							elseif choice == "󰅍 Copy Hash" then
								vim.fn.setreg("+", full_hash)
							elseif choice:match("Delete") then
								local confirm = vim.fn.input("Delete " .. target_branch .. "? (y/N): ")
								if confirm == "y" then
									run("branch -D " .. target_branch)
								end
							elseif choice:match("Rename") then
								local n = vim.fn.input("New name: ")
								if n ~= "" then
									run("branch -m " .. n)
								end
							end
						end
					)
				end,
			},
		},

		keys = {
			{
				"<leader>gg",
				function()
					require("gitgraph").draw({}, { all = true, max_count = 1000 })
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
