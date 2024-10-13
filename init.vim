call plug#begin()
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'folke/tokyonight.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'xiyaowong/transparent.nvim'
Plug 'willothy/nvim-cokeline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'nvim-lua/plenary.nvim'
Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v4.x'}
call plug#end()
  
let mapleader = ","

" Focus on the previous buffer
nnoremap <silent> <S-Tab> <Plug>(cokeline-focus-prev)
" Focus on the next buffer
nnoremap <silent> <Tab> <Plug>(cokeline-focus-next)

" Switch to the previous buffer
nnoremap <silent> <Leader>p <Plug>(cokeline-switch-prev)

" Switch to the next buffer
nnoremap <silent> <Leader>n <Plug>(cokeline-switch-next)



set nu
set autoindent expandtab tabstop=2 shiftwidth=2
set clipboard+=unnamedplus
" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P




colorscheme tokyonight-storm
lua << EOF
require("transparent").setup({
  -- table: default groups
  groups = {
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
    'EndOfBuffer',
  },
  -- table: additional groups that should be cleared
  extra_groups = {},
  -- table: groups you don't want to clear
  exclude_groups = {},
  -- function: code to be executed after highlight groups are cleared
  -- Also the user event "TransparentClear" will be triggered
  on_clear = function() end,
})

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
require('nvim-treesitter').setup({
auto_install = true,
  highlight = {
    enable = true}
}
)
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "clangd", "eslint", "biome"}
})

require("lspconfig").clangd.setup{
        -- Custom on_attach logic
    filetypes = { "c", "cpp", "objc", "objcpp" },  -- Specify the filetypes
}
require("lspconfig").biome.setup{}
require("lspconfig").eslint.setup{}


EOF


lua << EOF

  require("cokeline").setup()
EOF




lua << EOF
local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- Expand snippets using LuaSnip
        end,
    },
    mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'luasnip' },
    },
})

local lspconfig = require('lspconfig')

lspconfig.pyright.setup{} -- Example for Python
lspconfig.tsserver.setup{} -- Example for TypeScript
EOF
