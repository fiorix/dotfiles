" fiorix's vimrc
" 20110831rc1

" Use vim defaults.
set nocompatible

" Show some extra information.
set ruler
set magic
set showcmd
set showmode
set showmatch
set incsearch
set laststatus=2
set report=0

" Explicitly set the default tab to \t, not 8 spaces.
" Also set auto indent and allow backspace anywhere.
" For more info check this out:
" http://www.kernel.org/doc/Documentation/CodingStyle
set sw=8 noet
set bs=2
set ai

" History and .viminfo
set history=50
set viminfo='20,\"50

" Colors, syntax and search highlight.
syntax on
set hlsearch
set t_Co=256
hi Comment term=bold ctermfg=White
hi Search  term=bold ctermfg=Black ctermbg=DarkYellow

" Highlight cursor line.
set cursorline
hi CursorLine cterm=NONE ctermbg=DarkBlue ctermfg=White

" Highlight overlength lines.
set cc=80
hi ColorColumn ctermbg=DarkGrey

" Highlight trailing whitespace.
highlight WhitespaceEOL ctermbg=DarkRed
match WhitespaceEOL /\s\+$/

" C and C++ specific settings.
autocmd FileType c,cpp set cindent

" Python specific settings.
autocmd FileType python set expandtab tabstop=4 shiftwidth=4 softtabstop=4
