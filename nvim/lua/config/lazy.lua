-- Install lazy if not exist
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

--===========================My Configurations====================
vim.api.nvim_create_user_command("ToggleRelNum", function()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, {})
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.clipboard = "unnamedplus"
local map = vim.keymap.set

function _G.ToggleTheme()
	if vim.o.background == "light" then
		vim.o.background = "dark"
	else
		vim.o.background = "light"
	end
end

map("i", "jj", "<Esc>", { silent = true })
map("n", "<leader>tt", "<cmd>lua ToggleTheme()<CR>", { desc = "Toggle Theme" })
map("n", "<leader>rel", ":ToggleRelNum<CR>", { desc = "Toggle relative numbers" })
map("n", "<leader>m", ":mark<CR>", { desc = "Mark current line" })
map("n", "<leader>rs", vim.lsp.buf.rename)
map("n", "<leader>gd", vim.lsp.buf.definition, { noremap = true, silent = true })

--alt up or down to move
map("n", "<C-M-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<C-M-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<C-M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<C-M-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

--window actions
map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- Quickfix Navigation: Alt + j/k
map("n", "<M-j>", "<cmd>cnext<CR>", { desc = "Quickfix: Next item (Alt+j)" })
map("n", "<M-k>", "<cmd>cprev<CR>", { desc = "Quickfix: Previous item (Alt+k)" })

-- terminal
map(
	"n",
	"<leader>t",
	":botright split term://fish<CR>",
	{ desc = "Open terminal (horizontal split) with fish at the bottom" }
)

local function project_build()
	local build_script = vim.fn.getcwd() .. "/build.sh"

	if vim.fn.executable(build_script) == 1 then
		vim.notify("Running project build script: " .. build_script, vim.log.levels.INFO)
		vim.cmd("silent ! " .. build_script)
		vim.defer_fn(function()
			vim.notify("Build script finished!", vim.log.levels.INFO)
		end, 100)
	else
		vim.notify(build_script, vim.log.levels.WARN)
	end
end

-- Add the build shortcut
vim.keymap.set("n", "<leader>b", project_build, { desc = "Run project-specific build script" })

-- git
vim.keymap.set("n", "<leader>gc", function()
	local msg = vim.fn.input("Commit Message: ")
	if msg ~= "" then
		vim.cmd("!git commit -m " .. vim.fn.shellescape(msg))
	end
end, { desc = "Git Commit" })

-- -- telescope
-- map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
-- map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
-- map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
-- map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
-- map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
-- map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
-- map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
-- map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
-- map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

--===========================My Configurations====================

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = false },
	auto_install = true,
	auto_clean = true,
})
