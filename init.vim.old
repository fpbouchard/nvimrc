" vim: set ft=vim:


" VIM-PLUG
" ==============================================================

" Autoinstall vim-plug
" {{{
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}
call plug#begin('~/.nvim/plugged')


" NAVIGATION / SEARCH
" ==============================================================

Plug 'justinmk/vim-dirvish'
Plug 'kristijanhusak/vim-dirvish-git'
Plug 'roginfarrer/vim-dirvish-dovish', {'branch': 'main'}

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'kevinhwang91/nvim-bqf'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim'

Plug 'windwp/nvim-spectre'
" {{{
nnoremap <leader>S <cmd>lua require('spectre').open()<CR>

"search current word
nnoremap <leader>sw <cmd>lua require('spectre').open_visual({select_word=true})<CR>
vnoremap <leader>s <cmd>lua require('spectre').open_visual()<CR>
"  search in current file
nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>
" run command :Spectre
" }}}


" Find files using Telescope command-line sugar.
nnoremap <leader><leader> <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>rs <cmd>lua require('telescope.builtin').grep_string()<cr>
nnoremap <leader>rg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>b <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>B <cmd>lua require('telescope.builtin').oldfiles()<cr>
nnoremap <leader>h <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>o <cmd>lua require('telescope.builtin').treesitter()<cr>

nnoremap <leader>gc <cmd>lua require('telescope.builtin').git_commits()<cr>
nnoremap <leader>gh <cmd>lua require('telescope.builtin').git_bcommits()<cr>
nnoremap <leader>gb <cmd>lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>gs <cmd>lua require('telescope.builtin').git_status()<cr>

" AUTOCOMPLETE/LINT
" ==============================================================
"
Plug 'dense-analysis/ale'
" {{{
let g:ale_sign_column_always = 0
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1

let g:ale_linters = {
  \   'javascript': [],
  \   'typescript': [],
  \   'ruby': ['rubocop'],
  \   'dart': [],
  \   'json': ['jsonlint'],
  \   'terraform': []
  \}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': [],
\   'typescript': [],
\   'ruby': ['rubocop'],
\   'dart': [],
\   'json': ['fixjson'],
\   'vue': [],
\   'terraform': ['terraform']
\}

" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)
" }}}


Plug 'neoclide/coc.nvim', {'branch': 'release'}
" {{{

" Custom settings
inoremap <silent> <c-K> <C-r>=CocActionAsync('showSignatureHelp')<CR>

" Plugins
let g:coc_global_extensions = [
      \'coc-css',
      \'coc-eslint',
      \'coc-flutter',
      \'coc-git',
      \'coc-html',
      \'coc-java',
      \'coc-json',
      \'coc-markdownlint',
      \'coc-pairs',
      \'coc-prettier',
      \'coc-prisma',
      \'coc-solargraph',
      \'coc-sourcekit',
      \'coc-tsserver',
      \'coc-webpack',
      \'coc-yaml'
      \]

" Below is pasted from coc.nvim's homepage

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
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
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
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" }}}

" LANGUAGES
" ==============================================================

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
" Plug 'nvim-treesitter/playground'
" Plug 'sheerun/vim-polyglot'
" Plug 'dart-lang/dart-vim-plugin' " https://github.com/nvim-treesitter/nvim-treesitter/issues/2961
Plug 'delphinus/vim-firestore'

" Temporary fix so all terraform files are set as terraform filetype (fixes
" terraform-ls)
augroup terraform_filetype
    au!
    autocmd BufNewFile,BufRead *tf   set filetype=terraform
augroup END


" EDITING
" ==============================================================

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'


" TEXT OBJECTS
" ==============================================================

Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'


" TERMINAL & TESTS
" ==============================================================

Plug 'vim-test/vim-test'
" {{{
  nmap <silent> <leader>A :TestSuite<CR>
  nmap <silent> <leader>r :TestNearest<CR>
  nmap <silent> <leader>R :TestFile<CR>
  nmap <silent> <leader>p :TestLast<CR>

  " Easier to just press C-o to switch to normal mode in terminal
  tmap <C-o> <C-\><C-n>

  let test#strategy = "kitty"
  let test#java#runner = 'gradletest'
  let test#javascript#runner = 'jest'
" }}}


" GENERAL STATE / STATUSLINE / TABBAR / COLORSCHEME
" ==============================================================

Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'kshenoy/vim-signature'

Plug 'itchyny/lightline.vim'
" {{{

  let g:lightline = {
    \ 'colorscheme': 'everforest',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ],
    \   'right': [ [ 'coc_error', 'coc_warning', 'coc_hint', 'coc_info', 'lineinfo' ], [ 'percent' ],
    \              [ 'blame', 'filetype' ]]
    \ },
    \ 'tabline': {
    \   'left': [ [ 'buffers' ] ],
    \   'right': [ [ 'close' ] ]
    \ },
    \ 'inactive': {
    \   'left': [ ['relativepath'] ],
    \   'right': []
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }
  let g:lightline.component_function = {
    \ 'gitbranch' : 'FugitiveHead',
    \ 'gitstatus' : 'g:coc_git_status',
    \ 'blame'     : 'LightlineGitBlame'
    \ }
  let g:lightline.component_expand = {
    \ 'coc_error'   : 'LightlineCocErrors',
    \ 'coc_warning' : 'LightlineCocWarnings',
    \ 'coc_info'    : 'LightlineCocInfos',
    \ 'coc_hint'    : 'LightlineCocHints',
    \ 'coc_fix'     : 'LightlineCocFixes',
    \ 'buffers'     : 'lightline#bufferline#buffers'
    \ }
  let g:lightline.component_type = {
    \ 'coc_error'   : 'error',
    \ 'coc_warning' : 'warning',
    \ 'coc_info'    : 'tabsel',
    \ 'coc_hint'    : 'middle',
    \ 'coc_fix'     : 'middle',
    \ 'buffers'     : 'tabsel'
    \ }

  function! s:lightline_coc_diagnostic(kind, sign) abort
    let info = get(b:, 'coc_diagnostic_info', 0)
    if empty(info) || get(info, a:kind, 0) == 0
      return ''
    endif
    try
      let s = g:coc_user_config['diagnostic'][a:sign . 'Sign']
    catch
      let s = ''
    endtry
    return printf('%s %d', s, info[a:kind])
  endfunction

  function! LightlineCocErrors() abort
    return s:lightline_coc_diagnostic('error', 'error')
  endfunction

  function! LightlineCocWarnings() abort
    return s:lightline_coc_diagnostic('warning', 'warning')
  endfunction

  function! LightlineCocInfos() abort
    return s:lightline_coc_diagnostic('information', 'info')
  endfunction

  function! LightlineCocHints() abort
    return s:lightline_coc_diagnostic('hints', 'hint')
  endfunction

  function! LightlineGitBlame() abort
    let blame = get(b:, 'coc_git_blame', '')
    " return blame
    return winwidth(0) > 120 ? blame : ''
  endfunction

  autocmd User CocDiagnosticChange call lightline#update()

  set noshowmode " Remove duplicate information
" }}}

" Plug 'christianchiarulli/nvcode-color-schemes.vim'
" Plug 'arcticicestudio/nord-vim'
Plug 'sainnhe/everforest'

call plug#end()

" POST PLUGIN
" ==============================================================

" General settings
" ==============================================================
set clipboard=unnamed,unnamedplus

set title
set visualbell
set hidden          " hide buffers instead of closing
set lazyredraw      " speed up on large files
set showcmd         " Display incomplete commands.
set cmdheight=2
set undolevels=5000 " max undo levels
set nobackup
set nowritebackup
set noswapfile
set nowrap                        " Turn off line wrapping.
set scrolloff=3                   " Show 3 lines of context around the cursor.
set laststatus=2
set number          " show line numbers
set mouse=a

set autoread
" This makes sure that autoread gets triggered when nvim gets the focus
" Sadly, only works in GUI vim
au FocusGained * silent! checktime
" This will do the same after cursor inactivity
au CursorHold * checktime

set timeoutlen=500 " shorten the delay to wait when a mapped sequence is started
set updatetime=300 " default is 4000; time before CursorHold and various 'inactive' things trigger

" Split below and right
set splitbelow
set splitright

" Show tabs, trailing whitespaces, extends and precedes
set list
set listchars=tab:>-,trail:·,extends:>,precedes:<,nbsp:+

" INDENTATION
" ==============================================================
set expandtab     " replace <Tab> with spaces
set tabstop=2     " number of spaces that a <Tab> in the file counts for
set softtabstop=2 " remove <Tab> symbols as it was spaces
set shiftwidth=2  " indent size for << and >>
set shiftround    " round indent to multiple of 'shiftwidth' (for << and >>)


" SEARCH
" ==============================================================
set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.
set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if expression contains a capital letter.


" FOLDING
" ==============================================================
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99

" COLORSCHEME
" ==============================================================

set termguicolors
set background=dark

let g:everforest_background = 'hard'
let g:everforst_enable_italic = 1

colorscheme everforest

" MISC
" ==============================================================
set cursorline
set colorcolumn=120

" Initialize LUA plugins
lua <<EOF
-- Tree Sitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "phpdoc" }, -- phodoc fails installation, dart seg faults https://github.com/nvim-treesitter/nvim-treesitter/issues/2961
  highlight = {
    enable = true,
    disable = { "html" } -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1788
  },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
  indent = {
    enable = true,
    disable = { "java" }
  },
  playground = {
    enable = false,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}

-- Telescope
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<esc>"] = actions.close,
      },
    },
    scroll_strategy = "limit",
    path_display = { "smart" },
    dynamic_preview_title = true,
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden"
    }
  },
  pickers = {
    find_files = {
      hidden = true
    },
    buffers = {
      ignore_current_buffer = true,
      sort_mru = true,
      mappings = {
        i = {
          ["<c-d>"] = actions.delete_buffer,
        }
      }
    }
  }
}
require('telescope').load_extension('fzf')

require('spectre').setup{
  live_update = true,
}
EOF


" Clear the current search highlight by pressing Esc
nnoremap <silent> <esc><esc> :noh<CR><esc>

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if &filetype !~ 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction

" In visual mode, shift-J / shift-k moves and indents the selection
lua <<EOF
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
EOF


" NVIM
" ==============================================================
"set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175

" prettier
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

if filereadable(glob("~/.nvimrc.local"))
  source ~/.nvimrc.local
endif
