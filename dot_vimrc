" =======================================
" Basic Setup
" =======================================

" Normally this if-block is not needed, because `:set nocp` is done
" automatically when .vimrc is found. However, this might be useful
" when you execute `vim -u .vimrc` from the command line.
if &compatible
  " `:set nocp` has many side effects. Therefore this should be doneq
  " only when 'compatible' is set.
  set nocompatible
endif

packadd minpac
call minpac#init()
" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

" =======================================
" Display
" =======================================

set showmatch               " Set show matching parenthesis

" I - Disable the startup message
" a - Avoid pressing enter after saves
set shortmess=Ia

set title                 " change the terminal's title

set wildignore+=*tmp/**
set wildignore+=*coverage

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Ignore images and log files
set wildignore+=*.gif,*.jpg,*.png,*.log

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore node modules
set wildignore+=node_modules/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*

" Disable osx index files
set wildignore+=.DS_Store

" =======================================
" Theme/Styling
" =======================================
syntax on
set background=dark

call minpac#add('morhetz/gruvbox')

colorscheme gruvbox

" Allow direnv environment handling
call minpac#add('direnv/direnv.vim')

" =======================================
" Scrolling
" =======================================
set scrolloff=8                " Lines to keep above and below the cursor
set sidescrolloff=15           " Columns to keep on either side of cursor

" =======================================
" Per Project .vimrc
" =======================================
set exrc   " Load .vimrc in project directory
set secure " Disable unsafe commands in local .vimrc files

" =======================================
" Tabbing
" =======================================
set tabstop=2       " Number of spaces in 'soft' tabs
set softtabstop=2   " Number of spaces in 'soft' tabs
set shiftwidth=2    " For use with indent plugins and `tabstop` setting
set expandtab       " Use 'soft' tabs when using <Tab> character

" =======================================
" Statusline Setup
" =======================================

call minpac#add('vim-airline/vim-airline')

" =======================================
" Various
" =======================================
set go=-T         " Hide GUI toolbar
set mousehide     " Hide the mouse
set mouse=n       " Allow 'mouse' navigation in Normal (n) mode
set splitbelow    " When splitting, set new file on the bottom
set hidden        " Hide hidden files
set numberwidth=1 " Line number width

" =======================================
" Relative Line Numbers
" =======================================
set number relativenumber
call minpac#add('jeffkreeftmeijer/vim-numbertoggle')


" =======================================
" Plugin Configuration
" =======================================

call minpac#add('tpope/vim-abolish')
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-sensible')
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('tpope/vim-eunuch')
call minpac#add('tpope/vim-markdown')

call minpac#add('editorconfig/editorconfig-vim')


"iOS
call minpac#add('keith/swift.vim')
call minpac#add('keith/xcconfig.vim')


"Git
call minpac#add('airblade/vim-gitgutter')
call minpac#add('tpope/vim-fugitive')

"Language Packages
call minpac#add('leafgarland/typescript-vim')
call minpac#add('elzr/vim-json')
call minpac#add('othree/html5.vim')



" Inspiration/values from:
" https://github.com/mdespuits/dotfiles/blob/master/vimrc
" https://github.com/keith/dotfiles/blob/main/vimrc 