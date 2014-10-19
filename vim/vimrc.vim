" To include this file in your local .vimrc, add the following line to the
" start of your vimrc:
"
" so <path-to-this-file>

set nu                                            " Show newlines
set shiftwidth=4                                  " Ensure the shiftwidth=4
set tabstop=4                                     " Ensure the tabstop=4
set expandtab                                     " I hate tabs

if version >= 703
  hi ColorColumn ctermbg=7
  let &colorcolumn="80,".join(range(100,999), ",")  " Make sure I know where columns 80 and 100 are.
endif

set nocompatible                                  " Avoid some legacy vim sillyness
set backspace=indent,eol,start                    " Better backspace behavior
"set cursorline                                   " Highlight the current line

set shell=sh                                      " Ensure vim always uses bash

set scrolloff=3                                   " Add more top/bottom scroll margin
set ttyfast lazyredraw                            " Should make drawing faster

set ignorecase                                    " I really don't care about case
set smartcase                                     " Be smart about when case sensitivity matters.
set smarttab                                      " Only respect shiftwidth for code.
set showcmd                                       " Show the last command.
set showmatch                                     " When a bracket is typed, show its match.

set incsearch                                     " Search incrementally as I type.
set hlsearch                                      " Highlight search terms as I type.

if version >= 703
  set undofile                                    " Save undo history across sessions.
endif

set viewoptions=cursor,folds                      " Save cursor position and folds.

set wildmenu                                      " Enhanced completion
set wildmode=list:longest                         " Tab-completion should act like shell completion.
" set wildignorecase                                " (Case insensitive
                                                  " completion- not supported yet)

syntax on                                         " Enable syntax coloring

" Create a kick-ass statusline
set statusline=%t\ [%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set laststatus=2

" setup the runtimepath variable to insert local config
let s:portable = expand('<sfile>:p:h')
let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)

" Pathogen
execute pathogen#infect()
call pathogen#helptags()    " generate helptags for everything in 'runtimepath'
filetype plugin indent on

" jedi-vim
autocmd FileType python setlocal completeopt-=preview   " disable auto-doc window appearing
"let g:jedi#completions_enabled = 0                     " uncomment to disable completion

" vim-airline
let g:airline#extensions#tabline#enabled = 1

