

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
" set shell=fish
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
		lsp_saga = true,
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
		barbar = true,
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
    open_on_tab = true,
    filters = {
      dotfiles = false,
      exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
    },
    disable_netrw = true,
    hijack_netrw = true,
    -- open_on_setup = false,
    -- ignore_ft_on_setup = { "alpha" },
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
      root_folder_label = false,
  
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
require("bufferline").setup {
options = {
  -- Use nvim built-in lsp
  diagnostics = "nvim_lsp",
  -- Get out of the way on the left nvim-tree The location of
  offsets = {{
    filetype = "NvimTree",
    text = "File Explorer",
    highlight = "Directory",
    text_align = "left"
  }}
  }
}
EOF

" These commands will navigate through buffers in order regardless of which mode you are using
" e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
" nnoremap <silent>[b :BufferLineCycleNext<CR>
" nnoremap <silent>]b :BufferLineCyclePrev<CR>
" 
" " These commands will move the current buffer backwards or forwards in the bufferline
" nnoremap <silent><mymap> :BufferLineMoveNext<CR>
" nnoremap <silent><mymap> :BufferLineMovePrev<CR>
" 
" " These commands will sort buffers by directory, language, or a custom criteria
" nnoremap <silent>be :BufferLineSortByExtension<CR>
" nnoremap <silent>bd :BufferLineSortByDirectory<CR>
" nnoremap <silent><mymap> :lua require'bufferline'.sort_buffers_by(function (buf_a, buf_b) return buf_a.id < buf_b.id end)<CR>


" Move to previous/next
nnoremap <silent>    <A-,> <Cmd>BufferPrevious<CR>
nnoremap <silent>    <A-.> <Cmd>BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>    <A-<> <Cmd>BufferMovePrevious<CR>
nnoremap <silent>    <A->> <Cmd>BufferMoveNext<CR>
" Goto buffer in position...
nnoremap <silent>    <space>1> <Cmd>BufferGoto 1<CR>
nnoremap <silent>    <space>2> <Cmd>BufferGoto 2<CR>
nnoremap <silent>    <space>3> <Cmd>BufferGoto 3<CR>
nnoremap <silent>    <space>4> <Cmd>BufferGoto 4<CR>
nnoremap <silent>    <space>5> <Cmd>BufferGoto 5<CR>
nnoremap <silent>    <space>6> <Cmd>BufferGoto 6<CR>
nnoremap <silent>    <space>7> <Cmd>BufferGoto 7<CR>
nnoremap <silent>    <space>8> <Cmd>BufferGoto 8<CR>
nnoremap <silent>    <space>9> <Cmd>BufferGoto 9<CR>
nnoremap <silent>    <space>0> <Cmd>BufferLast<CR>
" Pin/unpin buffer
nnoremap <silent>    <A-p> <Cmd>BufferPin<CR>
" Close buffer
nnoremap <silent>    <A-c> <Cmd>BufferClose<CR>
" Wipeout buffer
"                          :BufferWipeout
" Close commands
"                          :BufferCloseAllButCurrent
"                          :BufferCloseAllButPinned
"                          :BufferCloseAllButCurrentOrPinned
"                          :BufferCloseBuffersLeft
"                          :BufferCloseBuffersRight
" Magic buffer-picking mode
nnoremap <silent> <C-p>    <Cmd>BufferPick<CR>
" Sort automatically by...
nnoremap <silent> <Space>bb <Cmd>BufferOrderByBufferNumber<CR>
nnoremap <silent> <Space>bd <Cmd>BufferOrderByDirectory<CR>
nnoremap <silent> <Space>bl <Cmd>BufferOrderByLanguage<CR>
nnoremap <silent> <Space>bw <Cmd>BufferOrderByWindowNumber<CR>

lua <<EOF
local nvim_tree_events = require('nvim-tree.events')
-- local bufferline_state = require('bufferline.state')
local barbar = require('barbar.api')

local function get_tree_size()
  return require'nvim-tree.view'.View.width
end

nvim_tree_events.subscribe('TreeOpen', function()
  -- bufferline_state.set_offset(get_tree_size())
  barbar.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('Resize', function()
  -- bufferline_state.set_offset(get_tree_size())
  barbar.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('TreeClose', function()
  -- bufferline_state.set_offset(0)
  barbar.set_offset(0)
end)
EOF

" Other:
" :BarbarEnable - enables barbar (enabled by default)
" :BarbarDisable - very bad command, should never be used

lua << EOF
  require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF

lua <<EOF
 require'FTerm'.setup({
     border = 'double',
     dimensions  = {
         height = 0.5,
         width = 0.5,
     },
     cmd = os.getenv('SHELL'),
 })
 
 vim.keymap.set('n', '<A-i>', '<CMD>lua require("FTerm").toggle()<CR>')
 vim.keymap.set('t', '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
EOF

lua << END
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
END

lua <<EOF
require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
EOF

lua <<EOF
require('neoscroll').setup()

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

lua <<EOF
require("toggleterm").setup()
EOF

