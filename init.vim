set wildmenu
set wildmode=longest:full,full  " get bash-like tab completions
set cc=120                   " set an 80 column border for good coding style
filetype plugin indent on   " allows auto-indenting depending on file type
set tabstop=4               " number of columns occupied by a tab character
set shiftwidth=4            " width for autoindents
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set number
set mouse=a
set undofile

call plug#begin('~/AppData/Local/nvim/plugged')

Plug 'romgrk/barbar.nvim'
 
 " -- syntax highlight and linting
 Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
 
 " -- tree-view of current symbols
 Plug 'simrat39/symbols-outline.nvim'

 " -- indent lines
 Plug 'lukas-reineke/indent-blankline.nvim'

 " -- autocomplete functionality
 Plug 'neovim/nvim-lspconfig'
 Plug 'hrsh7th/cmp-nvim-lsp'
 Plug 'hrsh7th/cmp-buffer'
 Plug 'hrsh7th/cmp-path'
 Plug 'hrsh7th/cmp-cmdline'
 Plug 'hrsh7th/nvim-cmp'
 Plug 'dcampos/nvim-snippy'
 Plug 'dcampos/cmp-snippy'
 " -- alternative
 Plug 'neoclide/coc.nvim', {'branch': 'release'}

 " -- bracket pair
 Plug 'jiangmiao/auto-pairs'
 " -- find in file stuff
 Plug 'nvim-telescope/telescope.nvim'
 Plug 'nvim-lua/plenary.nvim'
 Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
 Plug 'nvim-telescope/telescope-fzy-native.nvim'
 Plug 'BurntSushi/ripgrep'

 " -- nvim line prettifier
 Plug 'nvim-lualine/lualine.nvim'
 " -- file tree
 Plug 'kyazdani42/nvim-tree.lua'

 "-- sneaking some formatting in here too
 Plug 'prettier/vim-prettier'
 Plug 'preservim/nerdcommenter'
 Plug 'mhinz/vim-startify'
" -- colour themes
 Plug 'dracula/vim', { 'as': 'dracula' }
 Plug 'ayu-theme/ayu-vim'
 " -- web icons
 Plug 'ryanoasis/vim-devicons'
 Plug 'kyazdani42/nvim-web-devicons'

call plug#end()

" ------------ MISC STUFF ------------

" -- find-in-file functionality
" find files in curr dir
nnoremap <C-f><C-p> <cmd>Telescope find_files<cr>
" find hovered string in curr dir
nnoremap <C-f><C-g> <cmd>Telescope grep_string<cr>
" find searched string in curr dir
nnoremap <C-f><C-a> <cmd>Telescope live_grep find_command=rg<cr>
lua <<EOF
require('telescope').setup {
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}
require('telescope').load_extension('fzy_native')
EOF
" find searched string in curr buffer
nnoremap <C-f><C-f> <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>


" -- set appearance
set encoding=UTF-8

"let ayucolor="light"  " for light version of theme
let ayucolor="mirage" " for mirage version of theme
"let ayucolor="dark"   " for dark version of theme
colorscheme ayu

lua <<EOF
vim.opt.list = true

require("indent_blankline").setup {
    show_end_of_line = false,
	show_current_context = true,
    show_current_context_start = true,
	show_trailing_blankline_indent = false,
	char = '¦',
	space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}
EOF

" -- copy-paste and line manipulation stuff
" -- <F2> is copy, <F3> is cut, <F3> is paste
map <F2> "+yi
map <F3> "+c
map <F4> <ESC>"+pa
imap <F4> <ESC>"+pa
set pastetoggle=<F1>
" --move line with Ctrl-[arrow]
nnoremap <C-Down>	:m .+1<CR>==
nnoremap <C-Up>		:m .-2<CR>==
inoremap <C-Down>	<Esc>:m .+1<CR>==gi
inoremap <C-Up>		<Esc>:m .-2<CR>==gi
vnoremap <C-Down>	:m '>+1<CR>gv=gv
vnoremap <C-Up>		:m '<-2<CR>gv=gv

autocmd BufReadPost * silent! normal! g`"zv

" --nerdcommenter
filetype plugin on
" Create default mappings
let g:NERDCreateDefaultMappings = 1
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1

map <silent> <A-c> <plug>NERDCommenterComment
lua <<EOF
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {},
    lualine_c = {
    {
      'filename',
      file_status = true,      -- Displays file status (readonly status, modified status)
      path = 1,                -- 0: Just the filename
                               -- 1: Relative path
                               -- 2: Absolute path

      shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
                               -- for other components. (terrible name, any suggestions?)
      symbols = {
        modified = '[+]',      -- Text to show when the file is modified.
        readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
        unnamed = '[No Name]', -- Text to show for unnamed buffers.
	  }
	 }
	},
    lualine_x = 
	{
		{
      'diagnostics',

      -- Table of diagnostic sources, available sources are:
      --   'nvim_lsp', 'nvim_diagnostic', 'coc', 'ale', 'vim_lsp'.
      -- or a function that returns a table as such:
      --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
      sources = { 'nvim_lsp' },

      -- Displays diagnostics for the defined severity types
      sections = { 'error', 'warn', 'info', 'hint' },

      diagnostics_color = {
        -- Same values as the general color option can be used here.
        error = 'DiagnosticError', -- Changes diagnostics' error color.
        warn  = 'DiagnosticWarn',  -- Changes diagnostics' warn color.
        info  = 'DiagnosticInfo',  -- Changes diagnostics' info color.
        hint  = 'DiagnosticHint',  -- Changes diagnostics' hint color.
      },
      symbols = {error = '', warn = ' ', info = ' ', hint = ' '},
      colored = true,           -- Displays diagnostics status in color if set to true.
      update_in_insert = false, -- Update diagnostics in insert mode.
      always_visible = false,   -- Show diagnostics even if there are none.
    }
	},
    lualine_y = {'location','progress'},
    lualine_z = {'branch', 'diff', 'diagnostics'}
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
  extensions = {}
}
EOF

" -- tree-like symbol view of curr project
lua <<EOF
	vim.g.symbols_outline = {
	    highlight_hovered_item = true
	}
EOF
map <S-F12> :SymbolsOutline

lua <<EOF
	require'nvim-web-devicons'.setup {
		-- globally enable default icons (default to false)
		-- will get overriden by `get_icons` option
		default = true;
	}
EOF



" --------- RUST ANALYZER LINT ----------

" Required for operations modifying multiple buffers like rename.
set hidden

lua <<EOF
	require'nvim-treesitter.configs'.setup {
	  -- A list of parser names, or "all"
	  ensure_installed = { "c", "lua", "rust" },
	
	  -- Install parsers synchronously (only applied to `ensure_installed`)
	  sync_install = false,
	
	  -- List of parsers to ignore installing (for "all")
	  ignore_install = { "javascript" },
	
	  highlight = {
	    -- `false` will disable the whole extension
	    enable = true,
	
	    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
	    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
	    -- the name of the parser)
	    -- list of language that will be disabled
	    -- disable = { "c", "rust" },
	
	    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
	    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
	    -- Using this option may slow down your editor, and you may see some duplicate highlights.
	    -- Instead of true it can also be a list of languages
	    additional_vim_regex_highlighting = false,
	  },
	}
EOF

map <silent> <S-F12> :call CocActionAsync('jumpDefinition')<CR>

" ----- TOP TABBING OF BUFFERS ----

nnoremap <silent>    <C-t> :enew<CR>
nnoremap <silent>    <C-w> :bdelete<CR>
" Move to previous/next
nnoremap <silent>    <A-,> :BufferPrevious<CR>
nnoremap <silent>    <A-.> :BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>    <A-<> :BufferMovePrevious<CR>
nnoremap <silent>    <A->> :BufferMoveNext<CR>
" Goto buffer in position...
nnoremap <silent>    <A-1> :BufferGoto 1<CR>
nnoremap <silent>    <A-2> :BufferGoto 2<CR>
nnoremap <silent>    <A-3> :BufferGoto 3<CR>
nnoremap <silent>    <A-4> :BufferGoto 4<CR>
nnoremap <silent>    <A-5> :BufferGoto 5<CR>
nnoremap <silent>    <A-6> :BufferGoto 6<CR>
nnoremap <silent>    <A-7> :BufferGoto 7<CR>
nnoremap <silent>    <A-8> :BufferGoto 8<CR>
nnoremap <silent>    <A-9> :BufferLast<CR>
" Pin/unpin buffer
nnoremap <silent>    <A-p> :BufferPin<CR>
" Close buffer
nnoremap <silent>    <A-c> :BufferClose<CR>
" Wipeout buffer
"                          :BufferWipeout<CR>
" Close commands
"                          :BufferCloseAllButCurrent<CR>
"                          :BufferCloseAllButPinned<CR>
"                          :BufferCloseBuffersLeft<CR>
"                          :BufferCloseBuffersRight<CR>
" Magic buffer-picking mode
nnoremap <silent> <C-s>    :BufferPick<CR>
" Sort automatically by...
nnoremap <silent> <Space>bb :BufferOrderByBufferNumber<CR>
nnoremap <silent> <Space>bd :BufferOrderByDirectory<CR>
nnoremap <silent> <Space>bl :BufferOrderByLanguage<CR>
nnoremap <silent> <Space>bw :BufferOrderByWindowNumber<CR>

" Other:
" :BarbarEnable - enables barbar (enabled by default)
" :BarbarDisable - very bad command, should never be used

" ---------- FILE TREE STUFF ------------------

let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could
" break rendering if you set an empty string depending on your font. let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a
" separator between symlinks' source and target.
let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
let g:nvim_tree_create_in_closed_folder = 1 "0 by default, When creating files, sets the path of a file when cursor is on a closed folder to the
" parent folder when 0, and inside the folder when 1.
let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile

" default will show icon by default if no icon is provided
" default shows no icon by default
let g:nvim_tree_icons = {
     \ 'default': "",
    \ 'symlink': "",
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

lua require'nvim-tree'.setup {}

nnoremap <C-b> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
" More available functions:
" " NvimTreeOpen
" " NvimTreeClose
" " NvimTreeFocus
" " NvimTreeResize
" " NvimTreeCollapse
" " NvimTreeCollapseKeepBuffers
"
set termguicolors " this variable must be enabled for colors to be applied properly

" a list of gromtu-ps can be found at `:help nvim_tree_highlight` highlight NvimTreeFolderIcon guibg=blue
set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
     --  { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['rust_analyzer'].setup {
    capabilities = capabilities
  }
EOF


