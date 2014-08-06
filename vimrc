" fiorix's vimrc

" Go plugins.
filetype off
filetype plugin indent off
set runtimepath+=/opt/go/misc/vim
filetype plugin indent on

" Misc
set nocompatible
set splitright
colorscheme pablo

" Avoid clear screen at exit.
set t_ti= t_te=

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

" set case-insensitive search instead of always search with \c as /\cfoobar
set ic

" History and .viminfo
set history=50
set viminfo='20,\"50

" Colors, syntax and search highlight.
syntax on
set hlsearch
set t_Co=256
hi Comment term=bold ctermfg=White
hi Search term=bold ctermfg=Black ctermbg=DarkYellow

" Highlight cursor line.
set cursorline
hi CursorLine cterm=NONE ctermbg=DarkRed

" Highlight overlength lines.
if exists('+colorcolumn')
	set colorcolumn=80
	hi ColorColumn ctermbg=DarkGrey
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Highlight trailing whitespace.
highlight WhitespaceEOL ctermbg=DarkRed
match WhitespaceEOL /\s\+$/

" Go settings: use goimports and run gofmt on save.
let g:gofmt_command="goimports"
autocmd FileType go autocmd BufWritePre <buffer> Fmt

" C and C++ indent.
autocmd FileType c,cpp set cindent

" Python indent.
autocmd FileType python set expandtab tabstop=4 shiftwidth=4 softtabstop=4

" Markdown.
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" Optional tab sizes.
map \1 <Esc>:set expandtab tabstop=1 shiftwidth=1 softtabstop=1<CR>
map \2 <Esc>:set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>
map \4 <Esc>:set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
map \t <Esc>:set noexpandtab tabstop=8 shiftwidth=8 softtabstop=0<CR>

" pathogen
call pathogen#infect()

" omni settings
set wildmode=list:longest
set completeopt=longest,menuone

" Syntastic fix: ignore errors about proprietary html for angularjs.
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
