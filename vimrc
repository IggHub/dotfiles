"  ____ ____ ____ ____ _
" ||I |||G |||G |||Y |||
" ||__|||__|||__|||__|||
" |/__\|/__\|/__\|/__\|/
"  ____ ____ ____ ____ ____
" ||V |||I |||M |||R |||C ||
" ||__|||__|||__|||__|||__||
" |/__\|/__\|/__\|/__\|/__\|

" Setup folding {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Plugins {{{
call plug#begin('~/.vim/plugged')
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
  Plug 'chriskempson/base16-vim'
  Plug 'arcticicestudio/nord-vim'
  Plug 'rakr/vim-one'
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'tomtom/tcomment_vim'
  Plug 'mattn/emmet-vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-sensible'
  Plug 'itchyny/lightline.vim'
  Plug 'Yggdroot/indentLine'
  Plug 'preservim/nerdtree'
  Plug 'luochen1990/rainbow'
  Plug 'tpope/vim-dispatch'
  Plug 'junegunn/vim-peekaboo'
  Plug 'machakann/vim-sandwich'
  Plug 'simnalamburt/vim-mundo'
call plug#end()
" }}}

" Basic setup {{{
set clipboard=unnamed
set noswapfile
set relativenumber number
set tabstop=2
set shiftwidth=2
set expandtab
set ignorecase
set smartcase
set hlsearch
set confirm
set hidden
set termguicolors

" Dictionary
let s:english_dict = "/usr/share/dict/words"

if filereadable(s:english_dict)
  let &dictionary=s:english_dict
endif

" show how many matches when searching with / or ?
set shortmess-=S
" }}}

" Theme {{{
set background=dark
colorscheme one
let g:airline_theme='one'
" }}}

" FZF  {{{
set rtp+=/usr/local/opt/fzf
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

command! -bang -nargs=* RgNoFile call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
command! -bang -nargs=* RgFile call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

" https://sts10.github.io/2016/01/10/vim-line-complete-with-fzf.html
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
" }}}

" Gutentags {{{
" https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['.git']

" Make it faster by ignoring these files
let g:gutentags_ctags_exclude = [
  \ '*.git', '*.svg', '*.hg',
  \ '*/tests/*',
  \ 'build',
  \ 'dist',
  \ '*sites/*/files/*',
  \ 'bin',
  \ 'node_modules',
  \ 'bower_components',
  \ 'cache',
  \ 'compiled',
  \ 'docs',
  \ 'example',
  \ 'bundle',
  \ 'vendor',
  \ '*.md',
  \ '*-lock.json',
  \ '*.lock',
  \ '*bundle*.js',
  \ '*build*.js',
  \ '.*rc*',
  \ '*.json',
  \ '*.min.*',
  \ '*.map',
  \ '*.bak',
  \ '*.zip',
  \ '*.pyc',
  \ '*.class',
  \ '*.sln',
  \ '*.Master',
  \ '*.csproj',
  \ '*.tmp',
  \ '*.csproj.user',
  \ '*.cache',
  \ '*.pdb',
  \ 'tags*',
  \ 'cscope.*',
  \ '*.css',
  \ '*.less',
  \ '*.scss',
  \ '*.exe', '*.dll',
  \ '*.mp3', '*.ogg', '*.flac',
  \ '*.swp', '*.swo',
  \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
  \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
  \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
\ ]
" }}}

" NERDTree {{{
let NERDTreeNaturalSort = 1
" }}}

" signify {{{
set updatetime=1000
" }}}

" rainbow {{{
let g:rainbow_active = 1
" }}}

" toggler {{{
function! ToggleNumber()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc
" }}}

" clear buffers {{{
" source:
" buffer delete
" https://stackoverflow.com/questions/4545275/vim-close-all-buffers-but-this-one

" getpos
" https://vi.stackexchange.com/questions/7761/how-to-restore-the-position-of-the-cursor-after-executing-a-normal-command
function! BufOnlySavePos()
let current_pos = getpos('.')
execute "%bd | e#"
call setpos('.', current_pos)
endfunc
" }}}

" mappings {{{
let mapleader = "\<space>"

" quick access to vimrc
if !has('nvim')
  nnoremap <Leader>vs :source $MYVIMRC<CR>
  nnoremap <Leader>ve :vsplit $MYVIMRC<CR>
elseif has('nvim')
  nnoremap <Leader>vs :source ~/.vimrc<CR>
  nnoremap <Leader>ve :vsplit ~/.vimrc<CR>
endif

" no highlight
nnoremap <Esc><Esc> :noh<Return><Esc>

" toggle numbers
nnoremap <leader>tn :call ToggleNumber()<CR>

" delete all buffers except current buffer
nnoremap <silent> <Leader>bd :call BufOnlySavePos()<CR>

" PLUGIN: FZF
nnoremap <silent> <C-b> :Buffers<CR>
nnoremap <silent> <C-f> :GFiles<CR>
imap <silent> <C-f> <plug>(fzf-complete-line)
nnoremap <silent> <Leader>f :RgNoFile<CR>
nnoremap <silent> <Leader>F :RgFile<CR>
nnoremap <silent> <Leader>/ :BLines<CR>
nnoremap <silent> <Leader>' :Marks<CR>
nnoremap <silent> <Leader>g :Commits<CR>
nnoremap <silent> <Leader>H :Helptags<CR>
nnoremap <silent> <Leader>hh :History<CR>
nnoremap <silent> <Leader>h: :History:<CR>
nnoremap <silent> <Leader>h/ :History/<CR>

" PLUGIN: NERDTree
nnoremap <Leader>nf :NERDTreeFind<CR>
nnoremap <Leader>nt :NERDTreeToggle<CR>

" PLUGIN: Mundo
nnoremap <Leader>u :MundoToggle<CR>
" }}
