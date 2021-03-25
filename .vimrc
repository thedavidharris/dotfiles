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

" Plugins
call minpac#add('morhetz/gruvbox')

call minpac#add('tpope/vim-unimpaired')
call minpac#add('tpope/vim-surround')
call minpac#add('vim-airline/vim-airline')
call minpac#add('vim-airline/vim-airline-themes')

"iOS
call minpac#add('keith/swift.vim')
call minpac#add('keith/xcconfig.vim')


"Git
call minpac#add('airblade/vim-gitgutter')
call minpac#add('tpope/vim-fugitive')

"Language Packages


" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

" Load the plugins right now. (optional)
"packloadall

colorscheme gruvbox
set background=dark    " Setting dark mode