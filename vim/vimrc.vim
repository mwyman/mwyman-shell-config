" To include this file in your local .vimrc, add the following line to the
" start of your vimrc:
"
" so <path-to-this-file>

let mapleader = ","                               " Make the leader key be sane

set nu                                            " Show newlines
set shiftwidth=4                                  " Ensure the shiftwidth=4
set tabstop=4                                     " Ensure the tabstop=4
set expandtab                                     " I hate tabs

set hidden                                        " Make buffers work right (change without requiring writing)

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

" Make the current directory always match the content of the active buffer
set autochdir

" Catch trailing whitespace, enabled with ,s
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" Create a kick-ass statusline (this will be useful on systems that can't run
" vim-airline).
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
let g:airline_powerline_fonts = 0                       " make sure powerline fonts are disabled
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.linenr = '␊'


" Buffer movement commands

" ,N will open empty buffer
nmap <leader>N :enew<CR> 

" ,n will move to the next buffer
nmap <leader>n :bnext<CR>

" ,p will move to the previous buffer
nmap <leader>p :bprevious<CR>

" ,bq will close the current buffer and move to the previous one
nmap <leader>bq :bp <BAR> bd #<CR>

" ,bl will show all open buffers and their status
nmap <leader>bl :ls<CR>

