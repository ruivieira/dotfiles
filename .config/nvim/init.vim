execute pathogen#infect()
syntax on
" associate *.erc with html filetype
au BufRead,BufNewFile *.erc setfiletype html

" install the nvim-finder (file explorer) plugin
Plug 'minodisk/nvim-finder', { 'do': ':FinderInstallBinary' }
