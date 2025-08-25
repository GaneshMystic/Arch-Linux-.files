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
vim.api.nvim_create_user_command(
    "ToggleRelNum",
    function()
        vim.opt.relativenumber = not vim.opt.relativenumber:get()
    end,
    {}
)
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.keymap.set("i", "jj", "<Esc>", {silent = true})
vim.keymap.set("n", "<leader>r", ":ToggleRelNum<CR>", {desc = "Toggle relative numbers"})
vim.keymap.set("n", "<leader>m", ":mark<CR>", {desc = "Mark current line"})

--add closing pair for quotes and brackets
vim.api.nvim_set_keymap('i', '(', '()<Left>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '[', '[]<Left>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '{', '{}<Left>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '"', '""<Left>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', "'", "''<Left>", {noremap = true, silent = true})
--===========================My Configurations====================

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})