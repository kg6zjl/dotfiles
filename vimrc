set nocompatible
syntax on
set ruler
set incsearch
set nostartofline
set ignorecase
set smartcase
set cursorline
set background=dark
set tabstop=4
set shiftwidth=4
set expandtab
set backspace=indent,eol,start
set hlsearch
set mouse=a
fixdel
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
match ExtraWhitespace /^\t\+/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd InsertLeave * redraw!
command! Wq wq
command! WQ wq
