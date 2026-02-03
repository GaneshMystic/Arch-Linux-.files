local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)
vim.api.nvim_create_user_command("ToggleRelNum", function()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, {})
_G.ToggleTheme = function()
	vim.o.background = (vim.o.background == "dark") and "light" or "dark"
end
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = "Error",
			[vim.diagnostic.severity.WARN] = "Warn",
			[vim.diagnostic.severity.INFO] = "Info",
			[vim.diagnostic.severity.HINT] = "Hint",
		},
	},
})

-------------------- Debug UI---------------------
-- local signs = {
-- 	DapBreakpoint = { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" },
-- 	DapBreakpointCondition = { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" },
-- 	DapLogPoint = { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" },
-- }
--
-- for name, opts in pairs(signs) do
-- 	vim.fn.sign_define(name, opts)
-- end
--
-- -- Set the color for the red dot (if your colorscheme doesn't provide it)
-- vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
-- vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#e51400" })
-- vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
--
-------------------- Debug UI---------------------
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.clipboard = "unnamedplus"

local map = vim.keymap.set
map("i", "jj", "<Esc>", { silent = true })
map("n", "<leader>tt", "<cmd>lua ToggleTheme()<CR>", { desc = "Toggle Theme" })
map("n", "<leader>rel", ":ToggleRelNum<CR>", { desc = "Toggle relative numbers" })
map("n", "<leader>rs", vim.lsp.buf.rename, { desc = "LSP Rename" })
map("n", "<leader>gd", vim.lsp.buf.definition, { desc = "LSP Definition" })
map("n", "<C-M-j>", ":m .+1<CR>==")
map("n", "<C-M-k>", ":m .-2<CR>==")
map("v", "<C-M-j>", ":m '>+1<CR>gv=gv")
map("v", "<C-M-k>", ":m '<-2<CR>gv=gv")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<M-j>", "<cmd>cnext<CR>")
map("n", "<M-k>", "<cmd>cprev<CR>")
map("n", "<leader>t", ":botright split term://fish<CR>")
map("n", "<leader>b", function()
	local script = vim.fn.getcwd() .. "/build.sh"
	if vim.fn.executable(script) == 1 then
		vim.cmd("silent ! " .. script)
		vim.notify("Build script finished!")
	else
		vim.notify("No build.sh found", vim.log.levels.WARN)
	end
end)
map("n", "<leader>gc", function()
	local msg = vim.fn.input("Commit Message: ")
	if msg ~= "" then
		vim.cmd("!git commit -m " .. vim.fn.shellescape(msg))
	end
end)

-- LSP & Diagnostics
vim.diagnostic.config({
	virtual_text = { spacing = 4, prefix = "•" },
	float = { border = "rounded" },
})
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		map("n", "<leader>ed", vim.diagnostic.open_float, { buffer = args.buf, desc = "Diagnostics" })
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "gomod", "gowork" },
	callback = function()
		vim.treesitter.start()
	end,
})

-- Plugin Setup
require("lazy").setup({
	spec = { { import = "plugins" } },
	install = { colorscheme = { "habamax" } },
	checker = { enabled = false },
})
