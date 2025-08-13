local Plug = vim.fn['plug#']

vim.g.mapleader = ' '
vim.opt.number = true
vim.opt.relativenumber = false

vim.api.nvim_create_user_command('ToggleRelNum', function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, {})

vim.keymap.set('i', 'jj', '<Esc>', { silent = true })
vim.keymap.set('n', '<leader>r', ':ToggleRelNum<CR>', { desc = 'Toggle relative numbers' })
vim.keymap.set('n', '<leader>m', ':mark<CR>', { desc = 'Mark current line' })

vim.call('plug#begin')

--vscode theme
Plug('Mofiqul/vscode.nvim')
Plug('nvim-lualine/lualine.nvim')

--file finder
Plug('nvim-lua/plenary.nvim')  -- 🔧 Required dependency for telescope
Plug('nvim-telescope/telescope.nvim', { ['tag'] = '0.1.8' })

--git
Plug('isakbm/gitgraph.nvim')
Plug('sindrets/diffview.nvim')

--lsp
Plug('mason-org/mason.nvim')
Plug('mason-org/mason-lspconfig.nvim')
Plug('neovim/nvim-lspconfig')

--info
Plug('liuchengxu/vim-which-key')

--file explorer
Plug('nvim-tree/nvim-tree.lua') --file explorer

--Quality of Life
Plug( 'nvimdev/dashboard-nvim') --splash screen
Plug( 'nvim-tree/nvim-web-devicons') --splash screen icons

vim.call('plug#end')


--=================== Theme ==================
-- Set background: 'dark' or 'light'
vim.o.background = 'dark'  -- or 'light'

-- Load and configure theme
local c = require('vscode.colors').get_colors()

require('vscode').setup({
  transparent = true,
  italic_comments = true,
  underline_links = true,
  disable_nvimtree_bg = true,
  terminal_colors = true,
  color_overrides = {
    vscLineNumber = '#FFFFFF',
  },
  group_overrides = {
        Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
  },
})

-- Activate theme
vim.cmd.colorscheme('vscode')
require('lualine').setup()
--===================Theme ==================

--===================Finder  ==================
-- use this to find if everything is ok with telescope.
-- vim.cmd(":checkhealth telescope")

if vim.fn.executable('rg') == 0 then
  vim.notify("❌ ripgrep can be installed by following this repo https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation", vim.log.levels.ERROR)
end

require('telescope').setup({
  pickers = {
    find_files = { theme = 'dropdown' },
  },
})
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader> ', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })

require('gitgraph').setup({
    git_cmd = 'git',
  format = {
    timestamp = '%H:%M:%S %d-%m-%Y',
    fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
  },
  hooks = {
    on_select_commit = function(commit)
      print('selected commit:', commit.hash)      
      vim.notify('DiffviewOpen ' .. commit.hash .. '^!')
      vim.cmd('DiffviewOpen ' .. commit.hash .. '^!')
    end,
    on_select_range_commit = function(from, to)
      print('selected range:', from.hash, to.hash)
      vim.notify('DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
      vim.cmd('DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
    end,
  },
})
local actions = require('diffview.actions')
require('diffview').setup({
  keymaps = {
    view = {
      { 'n', 'r', actions.refresh_files, { desc = 'Refresh diff view' } },
      { 'n', 'f', actions.toggle_files, { desc = 'Toggle file panel' } },
      { 'n', 'ff', actions.focus_files, { desc = 'Focus file panel' } },
      { 'n', 'x', '<Cmd>DiffviewClose<CR>', { desc = 'Close diff view' } },
    },
    file_panel = {
      { 'n', 'r', actions.refresh_files, { desc = 'Refresh file panel' } },
      { 'n', 'f', actions.toggle_files, { desc = 'Toggle file panel' } },
      { 'n', 'x', '<Cmd>DiffviewClose<CR>', { desc = 'Close diff view' } },
    },
    file_history_panel = {
      { 'n', 'r', actions.refresh_files, { desc = 'Refresh file history' } },
      { 'n', 'f', actions.toggle_files, { desc = 'Toggle file panel' } },
      { 'n', 'x', '<Cmd>DiffviewClose<CR>', { desc = 'Close diff view' } },
    },
  },
})
vim.keymap.set('n', '<leader>diff', ':DiffviewOpen<CR>', { desc = 'Open Git diff view' })
--===================GitGraph ================
--=================== LSP Config =============
require('mason').setup({
  ui = {
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
  },
})
require('mason-lspconfig').setup({
  ensure_installed = { 'ts_ls', 'clangd', 'clang-format' },
  automatic_installation = true,
})
--==================== File  Tree ===================

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = 'case_sensitive',
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

vim.keymap.set('n', '<leader>f', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader>e', ':NvimTreeFocus<CR>', { desc = 'Focus file explorer' })



--==================== File  Tree ===================
--====================  Splash Screen ===================

require('dashboard').setup({
  theme = 'hyper',
  config = {
    header={
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
[[_╱_______│___\|/___\_________`||/`________\\/_________\|/__________\\//\\//___\|/________]],
    },

    shortcut = {
      { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
    },
    footer = { "☢️ HI Mystic ☢️" },
  },
})



--====================  Splash Screen ===================


-- print("Config:", vim.fn.stdpath("config"))
-- print("Data:", vim.fn.stdpath("data"))
-- print("Cache:", vim.fn.stdpath("cache"))
-- print("State:", vim.fn.stdpath("state"))
-- print("Log:", vim.fn.stdpath("log"))

