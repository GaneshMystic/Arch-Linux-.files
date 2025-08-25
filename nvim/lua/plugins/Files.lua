return {
    {
        "nvim-tree/nvim-tree.lua",
        lazy = true,
        priority = 900,
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
            { "<leader>fe", "<cmd>NvimTreeFocus<CR>", desc = "Focus file explorer" },
        },
        config = function()
            require("nvim-tree").setup(
                {
                    sort = {
                        sorter = "case_sensitive"
                    },
                    view = {
                        width = 30
                    },
                    renderer = {
                        group_empty = true
                    },
                    filters = {
                        dotfiles = true
                    }
                }
            )
        end
    },{
        "nvim-telescope/telescope.nvim",
        lazy=false,
        priority=910,
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            if vim.fn.executable("rg") == 0 then
                vim.notify(
                    "❌ ripgrep can be installed by following this repo https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation",
                    vim.log.levels.ERROR
                )
            end

            require("telescope").setup(
                {
                    pickers = {
                        find_files = {theme = "dropdown"}
                    }
                }
            )
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader> ", builtin.find_files, {desc = "Find files"})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {desc = "Live grep"})
            vim.keymap.set("n", "<leader>fb", builtin.buffers, {desc = "Buffers"})
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, {desc = "Help tags"})
        end,
    }
}