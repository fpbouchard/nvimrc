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
  autocmd  FileType fzf set laststatus=0 noruler
    \| autocmd BufLeave <buffer> set laststatus=2 ruler

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


" AUTOCOMPLETE/LINT
" ==============================================================
"
Plug 'w0rp/ale'
" {{{
let g:ale_sign_column_always = 0
let g:ale_fix_on_save = 0
let g:ale_linters_explicit = 1

let g:ale_linters = {
  \   'javascript': [],
  \   'typescript': [],
  \   'ruby': ['rubocop'],
  \   'dart': [],
  \   'json': ['jsonlint']
  \}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': [],
\   'typescript': [],
\   'ruby': ['rubocop'],
\   'dart': ['dartfmt'],
\   'json': ['fixjson'],
\   'vue': ['prettier']
\}

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" }}}


Plug 'neoclide/coc.nvim', {'branch': 'release'}
" {{{

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
if has("patch-8.1.1564")
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
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
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
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
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

" Remap keys for applying codeAction to the current line.
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

Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-rails'
"Plug 'JSON.vim'
Plug 'pangloss/vim-javascript'
"Plug 'mxw/vim-jsx'
"Plug 'ianks/vim-tsx'
Plug 'leafgarland/typescript-vim'
Plug 'ekalinin/Dockerfile.vim'
"Plug 'milch/vim-fastlane'
Plug 'neoclide/jsonc.vim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'posva/vim-vue'

Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

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
  nnoremap <silent> <Leader>gf :Gdiff<CR>
" }}}
Plug 'tpope/vim-bundler'
Plug 'kshenoy/vim-signature'

Plug 'itchyny/lightline.vim'
" {{{

  let g:lightline = {
    \ 'colorscheme': 'nord',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ],
    \   'right': [ [ 'coc_error', 'coc_warning', 'coc_hint', 'coc_info', 'lineinfo' ], [ 'percent' ],
    \              [ 'blame', 'filetype' ]]
    \ },
    \ 'inactive': {
    \   'left': [ ['relativepath'] ],
    \   'right': []
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }
  let g:lightline.component_function = {
    \ 'gitbranch' : 'fugitive#head',
    \ 'gitstatus' : 'g:coc_git_status',
    \ 'blame'     : 'LightlineGitBlame'
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

  function! LightlineGitBlame() abort
    let blame = get(b:, 'coc_git_blame', '')
    " return blame
    return winwidth(0) > 120 ? blame : ''
  endfunction

  autocmd User CocDiagnosticChange call lightline#update()

  set noshowmode " Remove duplicate information
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

" prettier
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

" re-highlight vue files from start when opening
" https://github.com/posva/vim-vue#my-syntax-highlighting-stops-working-randomly
autocmd FileType vue syntax sync fromstart


if filereadable(glob("~/.nvimrc.local"))
  source ~/.nvimrc.local
endif
