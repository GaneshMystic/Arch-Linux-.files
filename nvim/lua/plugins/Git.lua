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
					local current_head = vim.fn.systemlist("git -C " .. git_root .. " rev-parse HEAD")[1]
					local full_hash = vim.fn.systemlist("git -C " .. git_root .. " rev-parse " .. commit.hash)[1]

					local function run(cmd)
						local output = vim.fn.system("git -C " .. git_root .. " " .. cmd)
						local clean = output:gsub("^%s*(.-)%s*$", "%1")
						vim.api.nvim_echo(
							{ { "\nGit: ", "Identifier" }, { clean ~= "" and clean or "Action successful", "Normal" } },
							true,
							{}
						)
						gg.draw({}, { all = true, max_count = 1000 })
					end

					local target_branch = (commit.branch_names and #commit.branch_names > 0) and commit.branch_names[1]
						or nil
					if target_branch then
						target_branch = target_branch:gsub("HEAD %-> ", "")
					end

					local is_head = (full_hash == current_head)
					local is_curr_br = (target_branch == current_br)

					local menu = {
						{ key = "d", label = " Diff Split", id = "diff" },
						{ key = "y", label = "󰅍 Copy Hash", id = "copy" },
						{ key = "n", label = " Create New Branch", id = "create" },
					}
					if not is_head then
						table.insert(menu, { key = "p", label = " Cherry-pick", id = "cherry" })
					end

					if target_branch then
						if not is_curr_br then
							table.insert(
								menu,
								{ key = "c", label = " Checkout Branch: " .. target_branch, id = "checkout" }
							)
							if not is_head then
								table.insert(menu, { key = "m", label = " Merge " .. target_branch, id = "merge" })
							end
							table.insert(
								menu,
								{ key = "x", label = "󰆴 Delete Branch: " .. target_branch, id = "delete" }
							)
						end
						table.insert(menu, {
							key = "r",
							label = "󰑕 Rename Branch: " .. (is_curr_br and "Current" or target_branch),
							id = "rename",
						})
						if
							is_curr_br
							and vim.fn.system("git rev-parse --abbrev-ref " .. target_branch .. "@{u}"):match("fatal")
						then
							table.insert(menu, { key = "u", label = " Push Branch (Set Upstream)", id = "push" })
						end
					end

					local display = { { "Git Action (" .. commit.hash:sub(1, 7) .. "):\n", "Title" } }
					for _, item in ipairs(menu) do
						table.insert(display, { string.format("[%s]", item.key), "WarningMsg" })
						table.insert(display, { "   " .. item.label .. "\n", "Normal" })
					end
					vim.api.nvim_echo(display, true, {})

					local char = vim.fn.getcharstr()
					local action = nil
					for _, item in ipairs(menu) do
						if item.key == char then
							action = item.id
							break
						end
					end

					if action == "diff" then
						vim.cmd("DiffviewOpen " .. full_hash .. "^!")
					elseif action == "copy" then
						vim.fn.setreg("+", full_hash)
					elseif action == "create" then
						local name = vim.fn.input("New branch name: ")
						if name ~= "" then
							if vim.fn.input("Checkout " .. name .. "? (y/N): ") == "y" then
								run(string.format("checkout -b %s %s", name, full_hash))
							else
								run(string.format("branch %s %s", name, full_hash))
							end
						end
					elseif action == "cherry" then
						run("cherry-pick " .. full_hash)
					elseif action == "checkout" then
						run("checkout " .. target_branch)
					elseif action == "merge" then
						run("merge " .. target_branch)
					elseif action == "push" then
						run("push -u origin " .. current_br)
					elseif action == "delete" then
						if vim.fn.input("Delete " .. target_branch .. "? (y/N): ") == "y" then
							run("branch -D " .. target_branch)
						end
					elseif action == "rename" then
						local n = vim.fn.input("New name: ")
						if n ~= "" then
							run("branch -m " .. (is_curr_br and "" or target_branch .. " ") .. n)
						end
					end
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
