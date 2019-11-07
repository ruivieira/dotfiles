execute pathogen#infect()
syntax on
" associate *.erc with html filetype
au BufRead,BufNewFile *.erc setfiletype html

call plug#begin('~/.vim/plugged')
