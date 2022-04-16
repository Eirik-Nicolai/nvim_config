set wildmenu
set wildmode=longest:full,full  " get bash-like tab completions
"set cc=120                   " set an 80 column border for good coding style
filetype plugin indent on   " allows auto-indenting depending on file type
set tabstop=4               " number of columns occupied by a tab character
set shiftwidth=4            " width for autoindents
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set number
set mouse=a
set undofile
set cursorline
set splitright

autocmd VimEnter :set laststatus 3<CR>
autocmd VimEnter :hi VertSplit cterm=None guifg=#5c6773<CR>
autocmd VimEnter :hi CursorLine cterm=None guifg=#5c6773<CR>

set fillchars+=vert:\|

call plug#begin('~/AppData/Local/nvim/plugged')

 Plug 'romgrk/barbar.nvim'

 " -- syntax highlight and linting
 Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
 
 " -- tree-view of current symbols
 Plug 'simrat39/symbols-outline.nvim'

 " -- indent lines
 Plug 'lukas-reineke/indent-blankline.nvim'
 
 " -- ide functionality
 Plug 'autozimu/LanguageClient-neovim', {
     \ 'branch': 'next',
     \ 'do': 'bash install.sh',
     \ }

 Plug 'neoclide/coc.nvim', {'branch': 'release'}
 
 " -- TODO debugging
 "Plug 'mfussenegger/nvim-dap'

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

" ----------- FIND IN FILES --------------------
" find files in curr dir
map <A-f><A-p> <cmd>Telescope find_files<cr>
" find hovered string in curr dir
map <A-f><A-g> <cmd>Telescope grep_string<cr>
" find searched string in curr dir
map <A-f><A-a> <cmd>Telescope live_grep find_command=rg<cr>
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
map <A-f><A-f> <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>


" -- set appearance
set encoding=UTF-8

"let ayucolor="light"  " for light version of theme
let ayucolor="mirage" " for mirage version of theme
"let ayucolor="dark"   " for dark version of theme
colorscheme ayu

lua <<EOF
vim.opt.list = true
vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#171b24 gui=nocombine]]

require("indent_blankline").setup {
    show_end_of_line = false,
	show_current_context = true,
    show_current_context_start = true,
	show_trailing_blankline_indent = false,
	char = '¦',
	space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
	char_highlight_list = {
        "IndentBlanklineIndent1",
	},

	indent_blankline_show_trailing_blankline_indent = false,
	indent_blankline_space_char_blankline_highlight_list = {Error, "Function"},
	indent_blankline_use_treesitter = true,
}
EOF

" ------------- BRACKETS PAIRING ------------------

let g:AutoPairs = {'(':')', '[':']', '{':'}','<':'>',"'":"'",'"':'"', "`":"`", '```':'```', '"""':'"""', "'''":"'''"}
let g:AutoPairsShortcutFastWrap = '<A-p><A-p>'
let g:AutoPairsShortcutToggle = '<A-p><A-t>'
let g:AutoPairsFlyMode = 0

let g:AutoPairsShortcutFastWrap = '<S-q><S-q>'

" --------------- OVERRIDE KEYMAPPINGS ----------------
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

" ---------- CODE COMMENTING FEATURES ------------
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
    globalstatus = true,
  },
  sections = {
    lualine_a = {'mode'},
	lualine_b = {
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
	lualine_c = 
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
	lualine_x = {'branch', 'diff', 'diagnostics'},
    lualine_y = {'location','progress'},
	lualine_z = {},
  },
  tabline = {},
  extensions = {}
}

EOF





" --------------- SYMBOLS VIEW ----------------
lua <<EOF
	vim.g.symbols_outline = {
	    highlight_hovered_item = true
	}
EOF
map <silent> <S-F12> :SymbolsOutline

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

" Required for operations modifying multiple buffers like rename.
set hidden


" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>



let g:LanguageClient_diagnosticsDisplay = {}

let g:LanguageClient_serverCommands = {
	\ 'rust': ['rust-analyzer'],
    \ }

" note that if you are using Plug mapping you should not use `noremap` mappings.
nmap <F5> <Plug>(lcn-menu)
" Or map each action separately
nmap <silent>K <Plug>(lcn-hover)
map <silent> <F12> <Plug>(lcn-definition)
map <silent> <F10> <Plug>(lcn-rename)

autocmd CursorHold :call LanguagueClient#textDocument_hover()



" ----- TOP TABBING OF BUFFERS ----

" new/del tab
map <silent>    <C-t><C-t> :enew<CR>
map <silent>    <C-t><C-h> :new<CR>
map <silent>    <C-t><C-v> :vnew<CR>
map <silent>    <C-w> :bdelete<CR>
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
