" vim: set ft=vim:


" VIM-PLUG
" ==============================================================

" Autoinstall vim-plug
" {{{
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
" }}}
call plug#begin('~/.nvim/plugged')

" GLOBAL SETUP
let g:python_host_prog  = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'


" NAVIGATION / SEARCH
" ==============================================================

Plug 'scrooloose/nerdtree'
" {{{
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeDirArrows = 1
  let g:NERDTreeChDirMode = 2
  let g:NERDTreeAutoDeleteBuffer = 1
  let g:NERDTreeIgnore = ['node_modules']

  map <F6> :NERDTreeToggle<CR>
  map <F5> :NERDTreeFind<CR>
" }}}
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
" {{{
  let g:NERDTreeUpdateOnCursorHold = 0
  let g:NERDTreeUpdateOnWrite      = 0
" }}}

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" {{{
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
" }}}
Plug 'junegunn/fzf.vim'
" {{{
  let g:fzf_commits_log_options = '--color=always
    \ --format="%C(yellow)%h%C(red)%d%C(reset)
    \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'

  " Customize fzf colors to match your color scheme
  let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'] }

  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

  nnoremap <silent> <Leader><Leader> :Files<CR>
  nnoremap <silent> <Leader>b :Buffers<CR>
  nnoremap <silent> <Leader>o :BTags<CR>
  nnoremap <silent> <Leader>t :Tags<CR>
  nnoremap <silent> <leader>c  :Commits<CR>
  nnoremap <silent> <leader>cb :BCommits<CR>

  " Mapping selecting mappings
  nmap <leader><tab> <plug>(fzf-maps-n)
  xmap <leader><tab> <plug>(fzf-maps-x)
  omap <leader><tab> <plug>(fzf-maps-o)

  " Insert mode completion
  imap <c-x><c-k> <plug>(fzf-complete-word)
  imap <c-x><c-f> <plug>(fzf-complete-path)
  imap <c-x><c-l> <plug>(fzf-complete-line)

  " Global line completion (not just open buffers. ripgrep required.)
  inoremap <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({
    \ 'prefix': '^.*$',
    \ 'source': 'rg -n ^ --color always',
    \ 'options': '--ansi --delimiter : --nth 3..',
    \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

  " Rg with preview
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview('right:50%', '?'),
    \   <bang>0)

  nnoremap <silent> <Leader>rg :Rg <C-R><C-W><C-R><CR><CR>

  " Files command with preview window
  command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
" }}}


" AUTOCOMPLETE
" ==============================================================

Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
" {{{
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion.
" Coc only does snippet and additional edit on confirm.
inoremap <CR> <C-G>u<CR>

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" }}}

Plug 'w0rp/ale'
" {{{
let g:ale_sign_column_always = 1

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'ruby': ['rubocop']
\}

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" }}}

" LANGUAGES
" ==============================================================

Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'tpope/vim-rails'
"Plug 'kchmck/vim-coffee-script'
"Plug 'JSON.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
Plug 'ekalinin/Dockerfile.vim'
"Plug 'milch/vim-fastlane'
Plug 'neoclide/jsonc.vim'

" EDITING
" ==============================================================

Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'


" TEXT OBJECTS
" ==============================================================

Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'


" TERMINAL & TESTS
" ==============================================================

Plug 'junegunn/vim-emoji'
Plug 'kassio/neoterm'
" {{{
  let g:neoterm_default_mod = ":botright"
  let g:neoterm_autoscroll = 1
" }}}
Plug 'janko-m/vim-test'
" {{{
  nmap <silent> <leader>A :TestSuite<CR>
  nmap <silent> <leader>r :TestNearest<CR>
  nmap <silent> <leader>R :TestFile<CR>
  nmap <silent> <leader>p :TestLast<CR>

  " Easier to just press C-o to switch to normal mode in terminal
  tmap <C-o> <C-\><C-n>

  let test#strategy = "neoterm"
" }}}


" GENERAL STATE / STATUSLINE / TABBAR / COLORSCHEME
" ==============================================================

Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
" {{{
  nnoremap <silent> <Leader>gb :Gblame<CR>
  nnoremap <silent> <Leader>gd :Gdiff<CR>
" }}}
Plug 'tpope/vim-bundler'
Plug 'kshenoy/vim-signature'

Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
" {{{
  let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ],
    \   'right': [ [ 'linter_errors', 'linter_warnings', 'linter_ok' ], [ 'lineinfo' ], [ 'percent' ],
    \              [ 'filetype' ] ]
    \ },
    \ 'inactive': {
    \   'left': [ ['relativepath'] ],
    \   'right': []
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }
  let g:lightline.component_expand = {
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
  let g:lightline.component_type = {
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }
  let g:lightline.component_function = {
      \     'gitbranch': 'fugitive#head'
      \ }
  let g:lightline#ale#indicator_warnings = "?"
  let g:lightline#ale#indicator_errors = "!"
  let g:lightline#ale#indicator_ok = "-"
  set noshowmode " Remove duplicate information
" }}}

Plug 'airblade/vim-gitgutter'
" {{{
  let g:gitgutter_map_keys = 0
  let g:gitgutter_max_signs = 200
" }}}

Plug 'ludovicchabant/vim-gutentags'
" {{{
  let g:gutentags_file_list_command = 'rg --files'
" }}}

Plug 'frankier/neovim-colors-solarized-truecolor-only'

call plug#end()

" POST PLUGIN
" ==============================================================

" General settings
" ==============================================================
set clipboard=unnamed,unnamedplus

set title
set visualbell
set number          " show line numbers
set hidden          " hide buffers instead of closing
set lazyredraw      " speed up on large files
set laststatus=2    " Show the status line all the time
set showcmd         " Display incomplete commands.
set undolevels=5000 " max undo levels
set nobackup
set nowritebackup
set noswapfile
set nowrap                        " Turn off line wrapping.
set scrolloff=3                   " Show 3 lines of context around the cursor.

set autoread
" This makes sure that autoread gets triggered when nvim gets the focus
au FocusGained * silent! checktime

set timeoutlen=500 " shorten the delay to wait when a mapped sequence is started

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
" Set fold method -- currently 'manual' for performance reasons (dramatically
" accelerates opening files like routes.rb)
set foldmethod=manual
" Enable a fold column
set foldcolumn=4
" Disable folding by default
set nofoldenable
" Enable folding by <Leader>f
noremap <Leader>f :setlocal foldmethod=syntax foldcolumn=4<CR>


" COLORSCHEME
" ==============================================================
set termguicolors
colorscheme solarized
set background=dark
call togglebg#map("<F4>")


" MISC
" ==============================================================
set cursorline
set colorcolumn=200

" CTags - refresh tags
"map <Leader>c :!ctags --extra=+f --exclude=.git --exclude=log --exclude=compiled --exclude=tmp -R *<CR><CR>

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

" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()


" NVIM
" ==============================================================
"set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175


if filereadable(glob("~/.nvimrc.local"))
  source ~/.nvimrc.local
endif
