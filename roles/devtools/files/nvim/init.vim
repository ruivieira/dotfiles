execute pathogen#infect()
syntax on
" associate *.erc with html filetype
au BufRead,BufNewFile *.erc setfiletype html
set nocompatible
filetype plugin on

call plug#begin('~/.vim/plugged')

Plug 'tyru/open-browser.vim' " opens url in browser
Plug 'http://github.com/tpope/vim-surround' " Surrounding ysw)
Plug 'https://github.com/preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'https://github.com/ap/vim-css-color' " CSS Color Preview
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'https://github.com/vim-airline/vim-airline' 
Plug 'https://github.com/scrooloose/syntastic.git' "syntastic
Plug 'https://github.com/tpope/vim-fugitive.git' "vim-fugitive
Plug 'https://github.com/airblade/vim-gitgutter.git' "vim-gitgutter
Plug 'https://github.com/plasticboy/vim-markdown.git' "vim-markdown

" Python plugins
Plug 'davidhalter/jedi-vim'
Plug 'numirias/semshi'

" Rust plugins
Plug 'dense-analysis/ale'
Plug 'rust-lang/rust.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'

" zsh
Plug 'zsh-users/zsh-syntax-highlighting'

" Optional dependencies
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Debugging (needs plenary from above as well)
Plug 'mfussenegger/nvim-dap'

" Themes
Plug 'morhetz/gruvbox' " The one and only

" Vim Markdown and Wiki
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lervag/wiki.vim'
Plug 'iamcco/markdown-preview.nvim'

" Outliner
Plug 'vimoutliner/vimoutliner'

" Org-mode
Plug 'kristijanhusak/orgmode.nvim'

" Ansible plugin
Plug 'pearofducks/ansible-vim'

"Tree-sitter
Plug 'nvim-treesitter/nvim-treesitter'

call plug#end()

" sane shift-arrow to select and copy/paste
" shift+arrow selection
nmap <S-Up> v<Up>
nmap <S-Down> v<Down>
nmap <S-Left> v<Left>
nmap <S-Right> v<Right>
vmap <S-Up> <Up>
vmap <S-Down> <Down>
vmap <S-Left> <Left>
vmap <S-Right> <Right>
imap <S-Up> <Esc>v<Up>
imap <S-Down> <Esc>v<Down>
imap <S-Left> <Esc>v<Left>
imap <S-Right> <Esc>v<Right>

" NERDTree toggle
nmap <F6> :NERDTreeToggle<CR>

" copy/paste
vmap <C-c> y<Esc>i
vmap <C-x> d<Esc>i
map <C-v> pi
imap <C-v> <Esc>pi
imap <C-z> <Esc>ui

" As-you-type autocomplete
set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_completion_enabled = 1

" Configuring Go To Definition
nnoremap <C-LeftMouse> :ALEGoToDefinition<CR>

" Configuring fixers
let g:ale_fixers = { 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'] }

colorscheme gruvbox
set background=dark " use dark mode

" Extra extensions
au BufRead,BufNewFile *.zsh.tmpl set filetype=zsh
au BufRead,BufNewFile *.md set filetype=votl

let g:wiki_root = '~/Sync/notes'
let g:wiki_filetypes = ['md']
let g:wiki_link_extension = '.md'

" Ansible plugin configuration
let g:ansible_extra_keywords_highlight = 1
let g:ansible_name_highlight = 'b'

" init.vim
lua << EOF
require('orgmode').setup({
  org_agenda_files = {'~/Sync/notes/pages/*.org'},
  org_default_notes_file = '~/Sync/notes/pages/contents.org',
})
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}

EOF

