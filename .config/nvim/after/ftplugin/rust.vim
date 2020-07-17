nnoremap gd :ALEGoToDefinition<CR>
nnoremap gr :ALEFindReferences<CR>
nnoremap K :ALEHover<CR>
setlocal formatprg=rustfmt\ --emit\ stdout\ --color\ never\ -q\ --edition\ 2018
