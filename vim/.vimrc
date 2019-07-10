" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimcurrent/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! archlinux.vim


" For more option refer to /usr/share/vim/vimcurrent/vimrc_example.vim or the
" vim manual

" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Jul 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

if has('nvim')
    set runtimepath+=/usr/share/vim/vimfiles
    let g:powerline_loaded = 1
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
"set ruler		" show the cursor position all the time
if has('cmdline_info')
    set ruler " show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
    set showcmd " show partial commands in status line and
    " selected characters/lines in visual mode
endif

if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    "set statusline=%<%f\ " Filename
    "set statusline+=%w%h%m%r " Options
    "set statusline+=\ [%{&ff}/%Y] " filetype
    "set statusline+=\ [%{getcwd()}] " current dir
    "set statusline+=%=%-14.(%l,%c%V%)\ %p%% " Right aligned file nav info
endif

"powerline
let g:powerline_pycmd = "py3"
let g:Powerline_cache_file = "/home/cgirard/.vim/Powerline.cache"
"let g:Powerline_symbols = 'fancy'
set encoding=utf-8

set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set nu
"set tw=80
"set wrap
set colorcolumn=80
set tabstop=8
set expandtab
set smarttab
set shiftwidth=2
set shiftround
"set autoindent


" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=v
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  let g:hybrid_use_Xresources = 1
  "set t_Co=256
  set background=dark
  colorscheme hybrid
  hi Normal ctermbg=none
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set backupdir=/tmp
set pdev=iR5870C
set spelllang=fr
" set spell

" Buffers - explore/next: F12, Shift-F12.
nnoremap <silent> <F12> :BufExplorer<CR>
nnoremap <silent> <S-F12> :bn<CR>

" Open and close the taglist.vim separately
nmap <F7>  :TlistToggle<CR>
" Split to the right side of the screen
let g:Tlist_Use_Left_Window = 1
" Set the window width
let g:Tlist_WinWidth = 40
" Sort by the order
let g:Tlist_Sort_Type = "order"
" Do not display the help info
let g:Tlist_Compact_Format = 1
" If you are the last, kill yourself
let g:Tlist_Exit_OnlyWindow = 1
" Do not close tags for other files
let g:Tlist_File_Fold_Auto_Close = 1
" Do not show folding tree
let g:Tlist_Enable_Fold_Column = 0
" Always display one file tags
let g:Tlist_Show_One_File = 1

" Open and close the NERD_tree.vim separately
nmap <F8>  :NERDTreeToggle<CR>
let g:NERDTreeChDirMode=0
" Set the window width
let g:NERDTreeWinSize = 23
" Set the window position
let g:NERDTreeWinPos = "right"
" Auto centre
let g:NERDTreeAutoCenter = 0
" Not Highlight the cursor line
let g:NERDTreeHighlightCursorline = 0

" LaTeX Suite
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

" XML Folding
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

" Perl Folding
let perl_fold=1

" sh folding
let g:sh_fold_enabled= 3

" highlight whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

nmap <silent> <C-n> :exec &nu==&rnu? "se nu!" : "se rnu!"<CR>

" Turn on the WiLd menu
set wildmenu
" Ignore compiled files
set wildignore=*.o,*~,*.pyc

" Calendar
let g:calendar_monday = 1

" Syntastic
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
"let g:syntastic_mode_map = { 'mode': 'active',
"            \ 'active_filetypes': ['ruby', 'php', 'perl'],
"            \ 'passive_filetypes': ['puppet'] }
let g:syntastic_perl_checkers=['perl', 'perlcritic']
let g:syntastic_enable_perl_checker=1

" Source the vimrc file after saving it
if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC
endif

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=237
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=240

