" ****************************************************************
" Vim/Neovim builtin options.
" ****************************************************************

filetype plugin indent on
set expandtab
set tabstop=4
set shiftwidth=4
set scrolloff=2

set updatetime=100

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

autocmd BufWritePre * call TrimWhitespace()

set colorcolumn=80

set ruler
set number
set relativenumber

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

set encoding=utf-8

set mouse=a

" ****************************************************************
" Keybindings for builtins.
" ****************************************************************

inoremap kj <ESC>
vnoremap kj <ESC>

" Bindings for switching windows. Handled by tmux-navigator.
"noremap <C-h> <C-w>h
"noremap <C-j> <C-w>j
"noremap <C-k> <C-w>k
"noremap <C-l> <C-w>l

" Switching tabs
nnoremap <TAB> gt
nnoremap <S-TAB> gT

" Copy to system clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y

" Move up and down over visual lines
nnoremap k gk
nnoremap j gj

" Shortcuts for butterfingers.
command WQ wq
command Wq wq
command W w
command Q q

" ****************************************************************
" Install plugins.
" ****************************************************************

call plug#begin('~/.config/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
let g:gitgutter_sign_added = " "
let g:gitgutter_sign_removed = " "
let g:gitgutter_sign_modified = " "

Plug 'junegunn/goyo.vim'  " Distraction-free writing.
Plug 'junegunn/limelight.vim'  " Emphasize paragraph with cursor.
Plug 'dracula/vim'  " Dark colorscheme.
Plug 'airblade/vim-rooter'  " Automatically cd to project root on file open.
Plug 'ryanoasis/vim-devicons'  " Filetype icons from Nerd Font

Plug 'AndrewRadev/bufferize.vim'
Plug 'christoomey/vim-tmux-navigator'

Plug 'sheerun/vim-polyglot'
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "<c-n>"

Plug 'neovim/python-client'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'davidhalter/jedi-vim'
Plug 'goerz/jupytext.vim'  " Edit jupyter notebooks as markdown or script.
Plug 'tweekmonster/impsort.vim'  " Sort python imports and highlight imported names
Plug 'jpalardy/vim-slime' " Send text to tmux pane (useful for REPL)
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": "{right}"}
let g:slime_dont_ask_default = 1
let g:slime_no_mappings = 1
xmap <leader>c <Plug>SlimeRegionSend
nmap <leader>c <Plug>SlimeParagraphSend

Plug 'Raimondi/delimitMate'
Plug 'tmhedberg/SimpylFold' " Python code folding
Plug 'dense-analysis/ale'  " ALE for linting
let g:ale_linters = {'rust': ['rls']}
call plug#end()

" Fuzzy finder
set rtp+=/usr/local/opt/fzf

" Gitgutter
let g:gitgutter_max_signs=9999

" Nerdtree
map <C-n> :NERDTreeToggle <CR>
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeIgnore = ['\.pyc$', '\.DS_Store']

" General deoplete config
set completeopt-=preview

" Python completions.
let g:python3_host_prog = '/opt/miniconda3/envs/editors/bin/python'

let $VIRTUAL_ENV = $CONDA_PREFIX
let g:deoplete#enable_at_startup = 1
let g:jedi#popup_on_dot = 0
let g:jedi#completions_enabled = 0

" Jupytext -- edit jupyter notebooks as markdown or script
let g:jupytext_fmt = 'py'

" Color scheme.
colorscheme dracula

" Airline.
let g:airline_powerline_fonts = 0

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰ '
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'

" Font
set guifont=Fira_Mono_for_Powerline_Medium:h18

" Goyo
function! s:goyo_enter()
  call deoplete#toggle()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  Limelight
endfunction

function! s:goyo_leave()
  call deoplete#toggle()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Debugging
" Get the name of the syntax highlighting item under the cursor
function! SyntaxItem()
  echo synIDattr(synID(line("."),col("."),1),"name")
endfunction
