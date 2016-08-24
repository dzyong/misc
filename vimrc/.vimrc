set cscopeprg=gtags-cscope
if filereadable("GTAGS")
    execute "cs add GTAGS"
endif
if filereadable("Session.vim")
    execute "source Session.vim"
    autocmd VimLeave * :mksession!
endif
if !has("gui_running")
    set mouse=n
    set nocursorline
else
    set guifont=Consolas:h15:cANSI
    set guioptions-=T
    set mouse=a
    hi Normal guibg=#ebffeb guifg=black
    set cursorline
endif
nmap <C-RightMouse> <C-O>
set hlsearch
set ignorecase
set smartcase
set nobackup
set nowrap
syntax on
set laststatus=2
set smarttab
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set showcmd
set nocompatible
set backspace=indent,eol,start
filetype plugin indent on
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
nmap <C-l> :TlistToggle<CR>
nmap ff :cs find f <C-R><C-F><CR>
nmap fd :cs find g <C-R><C-W><CR>
nmap fs :cs find s <C-R><C-W><CR>
language C
set cscopequickfix=s-,c-,d-,i-,t-,e-,g-
set cst
nmap cn :cn<CR>
nmap cp :cp<CR>
nmap <C-n> :set nu!<CR>
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_lazy_update = 1
let g:ctrlp_extensions = ['funky']
let g:ctrlp_max_files = 1000000
let mapleader = ","
nmap <C-\> :CtrlPMRUFiles<CR>
nmap <C-b> :CtrlPBuffer<CR>
nmap <C-t> :CtrlPBufTagAll<CR>
inoremap ii <Esc>
