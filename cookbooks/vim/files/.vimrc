set backspace=indent,eol,start
set fenc=utf-8
set noswapfile
set autoread

set virtualedit=onemore
set cursorline
set smartindent
set showmatch
set wildmode=list:longest
set visualbell
set laststatus=2
set t_Co=256
set nocompatible
set hlsearch
set number

set hlsearch
set incsearch
set smartcase

syntax on
" colorscheme molokai
colorscheme atom-dark

cnoremap w!! w !sudo tee > /dev/null %<CR> :e!<CR>

