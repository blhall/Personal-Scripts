autocmd!
set nocompatible

behave mswin
set list
set listchars=tab:\|\ 
set diffexpr=MyDiff()
set nowrap
set lines=56
set columns=128
set number
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set ignorecase
set fileformats=dos
set fileformat=dos
set noequalalways
set cpoptions+=f
set browsedir=buffer
set autoindent
set winminheight=0
set formatoptions=clntq
colorscheme desert

set lazyredraw

" Map ctrl-keypad +/- to increment and decrement number under cursor.
noremap <C-kPlus> <C-A>
noremap <C-kMinus> <C-X>
