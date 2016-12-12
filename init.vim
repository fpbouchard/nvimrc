" vim: set ft=vim:


" VIM-PLUG
" ==============================================================

" Autoinstall vim-plug
" {{{
if empty(glob('~/.nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
" }}}
call plug#begin('~/.nvim/plugged')


" NAVIGATION / SEARCH
" ==============================================================

Plug 'scrooloose/nerdtree'
" {{{
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeDirArrows = 1
  let g:NERDTreeChDirMode = 2
  let g:NERDTreeAutoDeleteBuffer = 1

  map <F6> :NERDTreeToggle<CR>
  map <F5> :NERDTreeFind<CR>
" }}}

Plug 'junegunn/vim-slash'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" {{{
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
" }}}
Plug 'junegunn/fzf.vim'
" {{{
  let g:fzf_nvim_statusline = 0 " disable statusline overwriting

  nnoremap <silent> <Leader><Leader> :Files<CR>
  nnoremap <silent> <Leader>b :Buffers<CR>
  nnoremap <silent> <Leader>o :BTags<CR>
  nnoremap <silent> <Leader>t :Tags<CR>
  nnoremap <silent> <Leader>ag :Ag <C-R><C-W><C-R>
  imap <c-x><c-k> <plug>(fzf-complete-word)
  imap <c-x><c-f> <plug>(fzf-complete-path)
  imap <c-x><c-j> <plug>(fzf-complete-file-ag)
  imap <c-x><c-l> <plug>(fzf-complete-line)
" }}}

Plug 'mileszs/ack.vim'
" {{{
  let g:ackprg = 'ag --nogroup --nocolor --column'
" }}}


" AUTOCOMPLETE
" ==============================================================

" Plug 'Valloric/YouCompleteMe'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" {{{
  let g:deoplete#enable_at_startup = 1
  " let g:deoplete#omni#functions = {}
  " let g:deoplete#omni#functions.ruby = 'rubycomplete#Complete'
" }}}
"Plug 'fishbullet/deoplete-ruby'


" LANGUAGES
" ==============================================================

Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-rails'
Plug 'kchmck/vim-coffee-script'
Plug 'JSON.vim'
Plug 'robbles/logstash.vim'
Plug 'leafgarland/typescript-vim'
Plug 'ekalinin/Dockerfile.vim'


" EDITING
" ==============================================================

Plug 'tpope/vim-ragtag'
Plug 'bingaman/vim-sparkup'
" {{{
  let g:sparkupArgs = '--no-last-newline --expand-divs'
" }}}
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'neomake/neomake'
" {{{
  autocmd! BufWritePost * Neomake
  let g:neomake_open_list=2
" }}}


" TEXT OBJECTS
" ==============================================================

Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'nelstrom/vim-textobj-rubyblock'


" TERMINAL & TESTS
" ==============================================================

Plug 'junegunn/vim-emoji'
Plug 'kassio/neoterm'
" {{{
  let g:neoterm_run_tests_bg = 1
  let g:neoterm_raise_when_tests_fail = 1
  "let g:neoterm_close_when_tests_succeed = 1
  let g:neoterm_rspec_lib_cmd = 'zeus rspec'

  nmap <silent> <leader>A :call neoterm#test#run('all')<cr>
  nmap <silent> <leader>r :call neoterm#test#run('file')<cr>
  nmap <silent> <leader>R :call neoterm#test#run('current')<cr>
  nmap <silent> <leader>p :call neoterm#test#rerun()<cr>

  " toggle terminal
  nnoremap <silent> ,tt :Ttoggle<cr>
  " hide/close terminal
  nnoremap <silent> ,th :call neoterm#close()<cr>
  " clear terminal
  nnoremap <silent> ,tl :call neoterm#clear()<cr>
  " kills the current job (send a <c-c>)
  nnoremap <silent> ,tc :call neoterm#kill()<cr>
" }}}


" GENERAL STATE / STATUSLINE / TABBAR / COLORSCHEME
" ==============================================================

Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-bundler'
Plug 'kshenoy/vim-signature'
Plug 'itchyny/lightline.vim'
" {{{
  let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'relativepath', 'modified' ] ],
    \   'right': [ [ 'lineinfo' ], [ 'percent' ],
    \              [ 'neoterm', 'fileformat', 'fileencoding', 'filetype' ] ]
    \ },
    \ 'inactive': {
    \   'left': [ ['relativepath'] ]
    \ },
    \ 'component_function': {
    \   'neoterm': 'LightlineNeoterm'
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }
  set noshowmode " Remove duplicate information

  function! LightlineNeoterm()
    return g:neoterm_statusline
  endfunction
" }}}

Plug 'airblade/vim-gitgutter'
" {{{
  let g:gitgutter_map_keys = 0
  let g:gitgutter_max_signs = 200
" }}}

Plug 'ludovicchabant/vim-gutentags'
Plug 'junegunn/limelight.vim'
" {{{
  let g:limelight_default_coefficient = 0.7
  nmap <silent> gl :Limelight!!<CR>
" }}}

Plug 'frankier/neovim-colors-solarized-truecolor-only'

call plug#end()

" POST PLUGIN
" ==============================================================

" NEOTERM
" Dependency on vim-emoji, needs to be loaded
let g:neoterm_test_status = {
  \ 'running': emoji#for('running'),
  \ 'success': emoji#for('green_heart'),
  \ 'failed': emoji#for('broken_heart')
  \ }


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
set background=dark
colorscheme solarized
call togglebg#map("<F4>")


" MISC
" ==============================================================
set cursorline
set colorcolumn=80

" CTags - refresh tags
map <Leader>c :!ctags --extra=+f --exclude=.git --exclude=log --exclude=compiled --exclude=tmp -R *<CR><CR>

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
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

if filereadable(glob("~/.nvimrc.local"))
  source ~/.nvimrc.local
endif
