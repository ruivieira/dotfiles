#!/bin/bash
BUNDLES=~/.config/nvim/bundle
rm -Rf $BUNDLES/nerdtree
git clone git://github.com/scrooloose/nerdtree.git $BUNDLES/nerdtree
rm -Rf $BUNDLES/nim.vim
git clone git://github.com/zah/nim.vim.git $BUNDLES/nim.vim
rm -Rf $BUNDLES/syntastic
git clone git://github.com/scrooloose/syntastic.git $BUNDLES/syntastic
rm -Rf $BUNDLES/vim-airline
git clone git://github.com/vim-airline/vim-airline.git $BUNDLES/vim-airline
rm -Rf $BUNDLES/vim-fugitive
git clone git://github.com/tpope/vim-fugitive.git $BUNDLES/vim-fugitive
rm -Rf $BUNDLES/vim-gitgutter
git clone git://github.com/airblade/vim-gitgutter.git $BUNDLES/vim-gitgutter
rm -Rf $BUNDLES/vim-markdown
git clone https://github.com/plasticboy/vim-markdown.git $BUNDLES/vim-markdown
rm -Rf $BUNDLES/rust.vim
git clone --depth=1 https://github.com/rust-lang/rust.vim.git $BUNDLES/rust.vim
