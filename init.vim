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

" NAVIGATION / SEARCH
" ==============================================================

Plug 'justinmk/vim-dirvish'
Plug 'kristijanhusak/vim-dirvish-git'

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

Plug 'neoclide/coc.nvim', {'tag': '*', 'do': 'yarn install'}
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

set shortmess+=c
set signcolumn=yes

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Use <cr> for confirm completion.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)
function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" }}}

" LANGUAGES
" ==============================================================

Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-rails'
"Plug 'JSON.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'ianks/vim-tsx'
Plug 'leafgarland/typescript-vim'
Plug 'ekalinin/Dockerfile.vim'
"Plug 'milch/vim-fastlane'
Plug 'neoclide/jsonc.vim'
Plug 'dart-lang/dart-vim-plugin'
" {{{
 let dart_format_on_save = 1
" }}}

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
" }}}
Plug 'tpope/vim-bundler'
Plug 'kshenoy/vim-signature'

Plug 'itchyny/lightline.vim'
" {{{

  let g:lightline = {
    \ 'colorscheme': 'nord',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'relativepath', 'modified', 'coc_error', 'coc_warning', 'coc_hint', 'coc_info' ] ],
    \   'right': [ [ 'lineinfo' ], [ 'percent' ],
    \              [ 'filetype' ]]
    \ },
    \ 'inactive': {
    \   'left': [ ['relativepath'] ],
    \   'right': []
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '│', 'right': '│' }
    \ }
  let g:lightline.component_function = {
    \ 'gitbranch': 'fugitive#head'
    \ }
  let g:lightline.component_expand = {
    \ 'coc_error'   : 'LightlineCocErrors',
    \ 'coc_warning' : 'LightlineCocWarnings',
    \ 'coc_info'    : 'LightlineCocInfos',
    \ 'coc_hint'    : 'LightlineCocHints',
    \ 'coc_fix'     : 'LightlineCocFixes'
    \ }
  let g:lightline.component_type = {
    \ 'coc_error'   : 'error',
    \ 'coc_warning' : 'warning',
    \ 'coc_info'    : 'tabsel',
    \ 'coc_hint'    : 'middle',
    \ 'coc_fix'     : 'middle'
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

  autocmd User CocDiagnosticChange call lightline#update()

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

"Plug 'frankier/neovim-colors-solarized-truecolor-only'
"Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'

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
set cmdheight=2
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
" Set fold method -- currently 'manual' for performance reasons (dramatically
" accelerates opening files like routes.rb)
set foldmethod=manual
" Enable a fold column
set foldcolumn=4
" Disable folding by default
set nofoldenable


" COLORSCHEME
" ==============================================================
set termguicolors

colorscheme nord

"let g:gruvbox_italic=1
"colorscheme gruvbox

"colorscheme solarized
"set background=dark
"call togglebg#map("<F4>")


" MISC
" ==============================================================
set cursorline
set colorcolumn=200

" CTags - refresh tags (replaced by gutentags)
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


" NVIM
" ==============================================================
"set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175


if filereadable(glob("~/.nvimrc.local"))
  source ~/.nvimrc.local
endif
