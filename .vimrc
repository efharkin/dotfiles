" Appearance
filetype plugin indent on
syntax on
set number
set cursorline

" LaTeX stuff
let g:tex_flavor = "latex"

" Colors
" set termguicolors
" let g:onedark_terminal_italics = 1
" colorscheme onedark

" Searching
set incsearch " Match as words are typed.
set hlsearch  " Highlight matches
nnoremap <leader><space> :nohlsearch<CR> " Clear highlighted matches.

" Function to remove whitespace.
function! TrimWhitespace()
	let l:save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(l:save)
endfunction

nnoremap <F5> :call TrimWhitespace()<CR>

" Navigation
set mouse=a

" Misc
set lazyredraw
