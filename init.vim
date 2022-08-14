

" Fundamentals "{{{
" ---------------------------------------------------------------------

" init autocmd
autocmd!
" set script encoding
scriptencoding utf-8
" stop loading config if it's on tiny or small
if !1 | finish | endif

set nocompatible
set number
syntax enable
set fileencodings=utf-8,sjis,euc-jp,latin
set encoding=UTF-8
set title
set autoindent
set background=dark
set nobackup
set hlsearch
set showcmd
set cmdheight=1
set laststatus=2
set scrolloff=10
set expandtab
"let loaded_matchparen = 1
set shell=fish
set backupskip=/tmp/*,/private/tmp/*

" incremental substitution (neovim)
if has('nvim')
  set inccommand=split
endif

" Suppress appending <PasteStart> and <PasteEnd> when pasting
set t_BE=

set nosc noru nosm
" Don't redraw while executing macros (good performance config)
set lazyredraw
"set showmatch
" How many tenths of a second to blink when matching brackets
"set mat=2
" Ignore case when searching
set ignorecase
" Be smart when using tabs ;)
set smarttab
" indents
filetype plugin indent on
set shiftwidth=2
set tabstop=2
set ai "Auto indent
set si "Smart indent
set nowrap "No Wrap lines
set backspace=start,eol,indent
" Finding files - Search down into subfolders
set path+=**
set wildignore+=*/node_modules/*

" Turn off paste mode when leaving insert
autocmd InsertLeave * set nopaste

" Add asterisks in block comments
set formatoptions+=r

"}}}

" Highlights "{{{
" ---------------------------------------------------------------------
set cursorline
"set cursorcolumn

" Set cursor line color on visual mode
highlight Visual cterm=NONE ctermbg=236 ctermfg=NONE guibg=Grey40

highlight LineNr cterm=none ctermfg=240 guifg=#2b506e guibg=#000000

augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END

if &term =~ "screen"
  autocmd BufEnter * if bufname("") !~ "^?[A-Za-z0-9?]*://" | silent! exe '!echo -n "\ek[`hostname`:`basename $PWD`/`basename %`]\e\\"' | endif
  autocmd VimLeave * silent!  exe '!echo -n "\ek[`hostname`:`basename $PWD`]\e\\"'
endif

"}}}

" File types "{{{
" ---------------------------------------------------------------------
" JavaScript
au BufNewFile,BufRead *.es6 setf javascript
" TypeScript
au BufNewFile,BufRead *.tsx setf typescriptreact
" Markdown
au BufNewFile,BufRead *.md set filetype=markdown
" Flow
au BufNewFile,BufRead *.flow set filetype=javascript

set suffixesadd=.js,.es,.jsx,.json,.css,.less,.sass,.styl,.php,.py,.md

autocmd FileType coffee setlocal shiftwidth=2 tabstop=2
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

"}}}

" Imports "{{{
" ---------------------------------------------------------------------
runtime ./plug.vim
if has("unix")
  let s:uname = system("uname -s")
  " Do Mac stuff
  if s:uname == "Darwin\n"
    runtime ./macos.vim
  endif
endif

runtime ./maps.vim
"}}}

" Syntax theme "{{{
" ---------------------------------------------------------------------

" set background=dark
let g:catppuccin_flavour = "mocha" " latte, frappe, macchiato, mocha
lua << EOF
require("catppuccin").setup({
	dim_inactive = {
		enabled = false,
		shade = "dark",
		percentage = 0.15,
	},
	transparent_background = true,
	term_colors = false,
	compile = {
		enabled = false,
		path = vim.fn.stdpath "cache" .. "/catppuccin",
	},
	styles = {
		comments = { "italic" },
		conditionals = { "italic" },
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
	},
	integrations = {
		treesitter = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
			},
		},
		coc_nvim = false,
		lsp_trouble = false,
		cmp = true,
		lsp_saga = false,
		gitgutter = false,
		gitsigns = true,
		leap = false,
		telescope = true,
		nvimtree = {
			enabled = true,
			show_root = true,
			transparent_panel = false,
		},
		neotree = {
			enabled = false,
			show_root = true,
			transparent_panel = false,
		},
		dap = {
			enabled = false,
			enable_ui = false,
		},
		which_key = false,
		indent_blankline = {
			enabled = true,
			colored_indent_levels = false,
		},
		dashboard = true,
		neogit = false,
		vim_sneak = false,
		fern = false,
		barbar = false,
		bufferline = true,
		markdown = true,
		lightspeed = false,
		ts_rainbow = false,
		hop = false,
		notify = true,
		telekasten = true,
		symbols_outline = true,
		mini = false,
		aerial = false,
		vimwiki = true,
		beacon = true,
		navic = false,
		overseer = false,
	},
	color_overrides = {},
	highlight_overrides = {},
})
EOF

colorscheme catppuccin

"}}}

" Extras "{{{
" ---------------------------------------------------------------------
set exrc
"}}}

" NvimTree settings
lua << EOF
  local present, nvimtree = pcall(require, "nvim-tree")
  
  if not present then
    return
  end
  
  -- require("base46").load_highlight "nvimtree"
  
  local options = {
    filters = {
      dotfiles = false,
      exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
    },
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = { "alpha" },
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = false,
    },
    view = {
      adaptive_size = true,
      side = "left",
      width = 25,
      hide_root_folder = true,
    },
    git = {
      enable = false,
      ignore = true,
    },
    filesystem_watchers = {
      enable = true,
    },
    actions = {
      open_file = {
        resize_window = true,
      },
    },
    renderer = {
      highlight_git = false,
      highlight_opened_files = "none",
  
      indent_markers = {
        enable = false,
      },
  
       icons = {
         show = {
           file = true,
           folder = true,
           folder_arrow = true,
           git = false,
         },
   
         glyphs = {
           default = "",
           symlink = "",
           folder = {
             default = "",
             empty = "",
             empty_open = "",
             open = "",
             symlink = "",
             symlink_open = "",
             arrow_open = "",
             arrow_closed = "",
           },
           git = {
             unstaged = "✗",
             staged = "✓",
             unmerged = "",
             renamed = "➜",
             untracked = "★",
             deleted = "",
             ignored = "◌",
           },
         },
       },
    },
  }
-- check for any override
-- options = require("core.utils").load_override(options, "kyazdani42/nvim-tree.lua")
vim.g.nvimtree_side = options.view.side
nvimtree.setup(options)

EOF
" let g:NERDSpaceDelims = 1
" let g:NERDCompactSexyComs = 1
" let g:NERDCommentEmptyLines = 1
" let g:NERDToggleCheckAllLines = 1

nnoremap <leader>n :NvimTreeToggle<CR>
nnoremap <leader>N :NvimTreeFocus<CR>

lua << EOF
require('Comment').setup()
EOF

set spell

lua << EOF
require('spellsitter').setup()
EOF

lua <<EOF
require"fidget".setup{}
EOF

lua <<EOF
require('nvim-lightbulb').setup({autocmd = {enabled = true}})
EOF

lua << EOF
  require("trouble").setup {}
EOF
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap <leader>gr <cmd>TroubleToggle lsp_references<cr>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

set termguicolors
lua << EOF
require("bufferline").setup{}
EOF


" FZF

" Prefix all commands with Fz,
" so Files is Fzfiles, Rg is FzRg, etc.
" It's useful to autocomplete all fzf commands using :Fz<tab>
let g:fzf_command_prefix = 'Fz'

" Keeps the history of previous searches.
" You can use ctrl-n or ctr-p to navigate the history on a FZF window
let g:fzf_history_dir = '~/.local/share/fzf-history'


" vim: set foldmethod=marker foldlevel=0:
