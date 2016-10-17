" Misc
set nocompatible
set splitright
colorscheme monochrome
filetype plugin indent on

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
hi CursorLine cterm=NONE ctermbg=DarkGrey

" Highlight trailing whitespace and 80th column.
highlight WhitespaceEOL ctermbg=DarkRed
match WhitespaceEOL /\s\+$/
hi ColorColumn ctermbg=DarkGrey

" C and C++ setup.
autocmd FileType c,cpp set colorcolumn=80 cindent

" Python setup.
autocmd FileType python set colorcolumn=80 expandtab tabstop=4 shiftwidth=4 softtabstop=4

" YAML setup.
autocmd FileType yaml set expandtab tabstop=2 shiftwidth=2 softtabstop=2

" Go setup.
"autocmd BufNewFile,BufReadPost *.go set filetype=go
autocmd FileType go set colorcolumn=80

" Markdown.
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" Optional tab sizes.
map \1 <Esc>:set expandtab tabstop=1 shiftwidth=1 softtabstop=1<CR>
map \2 <Esc>:set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>
map \4 <Esc>:set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
map \t <Esc>:set noexpandtab tabstop=8 shiftwidth=8 softtabstop=0<CR>

" pathogen
call pathogen#infect()

" Go settings: use goimports and run gofmt on save.
let g:go_fmt_command="goimports"

" omni settings
set wildmode=list:longest
set completeopt=longest,menuone

" auto open tagbar
"autocmd VimEnter * nested :call tagbar#autoopen(1)
map <F8> :TagbarToggle<CR>

" Ignore some Syntastic errors about html.
let g:syntastic_html_tidy_ignore_errors = [
	\"trimming empty <i>",
	\"trimming empty <span>",
	\"<input> proprietary attribute \"autofocus\"",
	\"<input> proprietary attribute \"autocomplete\"",
	\"<input> proprietary attribute \"required\"",
	\"proprietary attribute \"ng-",
	\"proprietary attribute \"role\"",
	\"proprietary attribute \"hidden\"",
	\"trimming empty <b>",
	\"trimming empty <li>",
	\"<a> attribute \"href\" lacks value",
	\"<img> lacks \"alt\" attribute",
	\"<img> lacks \"src\" attribute",
	\"<form> lacks \"action\" attribute",
\]
