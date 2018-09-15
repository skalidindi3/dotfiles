" vim:foldenable:foldmethod=marker:foldlevel=0

" vim {{{
set nocompatible                                    " vi who?
set lazyredraw                                      " take it easy
set ff=unix                                         " always unix line endings
set backspace=eol,start,indent                      " allow backspace over line-endings
" }}}

" Keys (Remaps) {{{
" you know what i mean
cnoremap Wq wq
cnoremap Qa qa
cnoremap Cq cq
" expect consistency
nnoremap Y y$
vnoremap p pgvy
" navigate lines visually
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
" faster extremes
nnoremap H ^
vnoremap H ^
nnoremap L $
vnoremap L $
nnoremap J G
vnoremap J G
nnoremap K gg
vnoremap K gg
nnoremap <C-j> <PageDown>
nnoremap <C-k> <PageUp>
" smarter visual shifting
vnoremap < <gv
vnoremap > >gv
" folding
nnoremap <space> za
nnoremap - zc
nnoremap = zo
nnoremap _ zM
nnoremap + zR
" }}}

" Keys (Shortcuts) {{{
" leader-based macros
let mapleader = ','
nnoremap <leader>/ :noh<CR>
nnoremap <leader><leader> :tab split<CR>
nnoremap <leader>P :set paste!<CR>:set paste?<CR>
nnoremap <leader>sw :call HighlightCursorWord()<CR>
nnoremap <leader>n :tabnext<CR>
nnoremap <leader>p :tabprevious<CR>
nnoremap <silent> <leader>dk :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
nnoremap <leader>rv :so $MYVIMRC<CR>
nnoremap <leader>ev :tabnew $MYVIMRC<CR>
" }}}

" Keys (Testing My Neuroplasticity) {{{
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
" }}}

" Basic Display {{{
set showmode                                        " explicit visual/insert/etc
set number                                          " show line numbers
set ruler                                           " show cursor coordinates
set showcmd                                         " in visual mode, show selection stats
set list listchars=                                 " allow list mode so we can set listchars formatting
set listchars+=trail:•                              " show trailing spaces as "•"
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END
" }}}

" Status Line {{{
set laststatus=2                                    " always show statusline
set wildmenu                                        " show autocomplete menu for commands
set statusline=                                     " init statusline
set statusline+=%f\ -\ %y                           " filename - [filetype]
set statusline+=%m                                  " file modified flag
set statusline+=%=                                  " text-align right remainder
set statusline+=[%c\ :\ %l/%L\ (%p%%)]              " [x : y/Y (%)]
" }}}

" Indentation (TODO lang specific) {{{
set autoindent                                      " copy indentation from previous line
set tabstop=4                                       " size of <TAB>
set softtabstop=4                                   " backspace works on size of <TAB>
set expandtab                                       " convert <TAB> to spaces
set shiftwidth=4                                    " shifts quantized to 4 spaces
set listchars+=tab:»»                               " show tabs expanded as "»"*tabwidth
" }}}

" Searching {{{
set hlsearch                                        " highlight searches
set incsearch                                       " realtime show next match
set wrapscan                                        " wrap around
function! HighlightCursorWord()
    silent! exe printf('match IncSearch /\<%s\>/', expand('<cword>'))
endfunction
" }}}

" Mouse {{{
if has("mouse")
    if has("mouse_sgr")
        set ttymouse=sgr                            " avoid mouse not working past certain column
    else
        if !has('nvim')
            set ttymouse=xterm2                     " allow split dragging
        endif
    end
    set mouse=a                                     " allow mouse in all modes
endif
" }}}

" Code Folding {{{
set foldmethod=indent                               " automatically fold by indent level
set nofoldenable                                    " but don't fold by default
set foldminlines=0                                  " fold single-line nests too
" }}}

" Plug {{{
" Helper function to get Plug straight from vim
function! DownloadPlug()
    if has('nvim')
        silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    else
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    endif
    echom "Restart vim to use plugins"
    redraw!
endfunction

" Load appropriate version of Plug
if has('nvim')
    let plug_path = '~/.config/nvim/plugged'
else
    let plug_path = '~/.vim/plugged'
endif
if !empty(glob(substitute(plug_path, 'plugged', 'autoload', '') . '/plug.vim'))
    call plug#begin(plug_path)
endif

" Load modules if Plug is loaded
if exists(':Plug')
    " Searching
    Plug 'kien/ctrlp.vim'
    " Git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    " NERDTree
    Plug 'scrooloose/nerdtree'
    Plug 'jistr/vim-nerdtree-tabs'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    " Colors
    Plug 'romainl/Apprentice'
    Plug 'rakr/vim-one'
    " Syntax Highlighting
    Plug 'sheerun/vim-polyglot'
    " Misc
    Plug 'sjl/gundo.vim'
    Plug 'Yggdroot/indentLine'
    Plug 'terryma/vim-multiple-cursors'
    call plug#end()
endif

" vim-fugitive {{{
if !empty(glob(plug_path . '/vim-fugitive'))
    nnoremap <leader>gb :Gblame<CR>
endif
" }}}

" gitv {{{
if !empty(glob(plug_path . '/gitv'))
    nnoremap <leader>gl :Gitv<CR>
endif
" }}}

" ctrlp.vim {{{
if !empty(glob(plug_path . '/ctrlp.vim'))
    let g:ctrlp_working_path_mode = 'ra'
    if executable('ag')
        let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    endif
    nnoremap <C-b> :<C-U>CtrlPBuffer<CR>
endif
" }}}

" ag.vim {{{
if !empty(glob(plug_path . '/ag.vim'))
    let g:ag_working_path_mode = 'r'
    let g:ag_mapping_message_text = 'woot woot'
    let g:ag_qmapping_func = 'call AgSetMappings()'
    function! AgSetMappings()
        nnoremap <silent> <buffer> q  :cclose<CR>

        " select & close quickfix
        nnoremap <silent> <buffer> <CR>  <CR><C-w><C-w>:cclose<CR>
        nnoremap <silent> <buffer> <C-t> <C-w><CR><C-w>T:tabp<CR>:cclose<CR>:tabn<CR>
        nnoremap <silent> <buffer> <C-x> <C-W><CR><C-w>K:cclose<CR>
        nnoremap <silent> <buffer> <C-v> <C-w><CR><C-w>H<C-W>b<C-W>J<C-W>t:cclose<CR>

        " select & keep quickfix open
        nnoremap <silent> <buffer> cc    <CR>:copen<CR>
        nnoremap <silent> <buffer> ct    <C-w><CR><C-w>TgT<C-W><C-W>
        nnoremap <silent> <buffer> cx    <C-W><CR><C-w>K<C-w>b
        nnoremap <silent> <buffer> cv    :let b:height=winheight(0)<CR><C-w><CR><C-w>H:copen<CR><C-w>J:exe printf(":normal %d\<lt>c-w>_", b:height)<CR>
    endfunction

    nnoremap <C-f> :AgBuffer! 
    nnoremap <C-f><C-f> :Ag! 
endif
" }}}

" vim-gitgutter {{{
if !empty(glob(plug_path . '/vim-gitgutter'))
    nnoremap <leader>gg :GitGutter<CR>
endif
" }}}

" nerdtree {{{
if !empty(glob(plug_path . '/nerdtree'))
    " close vim if only NERDTree left
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

    let NERDTreeMapOpenInTab  = '<C-t>'
    let NERDTreeMapOpenSplit  = '<C-x>'
    let NERDTreeMapOpenVSplit = '<C-v>'
endif
" }}}

" vim-nerdtree-tabs {{{
if !empty(glob(plug_path . '/vim-nerdtree-tabs'))
    nnoremap <C-n> :NERDTreeTabsToggle<CR>
endif
" }}}

" gundo.vim {{{
if !empty(glob(plug_path . '/gundo.vim'))
    let g:gundo_right = 1
    let g:gundo_preview_bottom = 1
    nnoremap <leader>u :GundoToggle<CR>
endif
" }}}

" indentLine {{{
if !empty(glob(plug_path . '/indentLine'))
    " should match colorscheme LineNr ctermfg
    let g:indentLine_color_term = synIDattr(synIDtrans(hlID('LineNr')), 'fg')
    if &diff
        let g:indentLine_enabled = 0                " disable indentline for vimdiff
    endif
endif
" }}}

" vim-multiple-cursors {{{
if !empty(glob(plug_path . '/vim-multiple-cursors'))
    let g:multi_cursor_use_default_mapping=0
    let g:multi_cursor_next_key='<C-d>'
    let g:multi_cursor_quit_key='<Esc>'
endif
" }}}
" }}}

" Syntax Highlighting {{{
set background=dark                                 " easy on the eyes
syntax on                                           " enable syntax highlighting
colorscheme elflord                                 " barebones default to packaged vim colorscheme
if &diff
    silent! colorscheme apprentice                  " use a different theme for vimdiff
elseif (has("termguicolors"))
    set termguicolors                               " use 24b true color mode in neovim if available
    silent! colorscheme one                         " with a true color colorscheme if available
endif
" }}}

" TODOs {{{

" "More listchars (:h listchars)"
" * nbsp
" * extends/precedes
" * conceal
" ? split trailing chars to own section, with highlight group? http://vim.wikia.com/wiki/Highlight_unwanted_spaces

" http://stackoverflow.com/questions/24716804/inline-comments-in-vimrc-mappings
" "|" separates commands in vim, so use to comment remaps

" strip whitespace fn

" More Plugins
" geoffharcourt/one-dark.vim
" sheerun/vim-polyglot
" tpope/vim-surround
" lightline.vim
" tcomment / NERD_commenter
" 'pangloss/vim-javascript'
" 'mileszs/ack.vim'
" 'derekwyatt/vim-scala' ?
" YouCompleteMe / neocomplete
" vim-lldb / Conque-GDB
" http://tnerual.eriogerg.free.fr/vimqrc.html
" tabular
" wesQ3/vim-windowswap

" http://vimcolors.com/93/lizard/dark
" http://vimcolors.com/61/flatlandia/dark
" http://vimcolors.com/56/babymate256/dark
" http://vimcolors.com/54/Tomorrow-Night-Eighties/dark
" http://vimcolors.com/36/iceberg/dark
" http://vimcolors.com/243/material-theme/dark
" http://vimcolors.com/207/lapis256/dark
" http://vimcolors.com/183/spacegray/dark
" http://vimcolors.com/166/abra/dark
" http://vimcolors.com/151/muon/dark
" http://vimcolors.com/147/clearance/dark

" }}}

" Reminders {{{
    " <C-w>r            - swap panes
    " gt                - next tab
    " viw               - visual select inner word
    " A                 - start typing at end of line
    " O                 - start new line above cursor
    " :echo has("lua")  - check for depenedency
    " "*p               - paste from system clipboard
    " e                 - end of word
    " ge                - end of previous word
    " f                 - prefix for "find next"
    " t                 - prefix for "till next"
    " zz                - center screen on line
" }}}

" Random Notes {{{

" BloodDragon folds not green...
" BloodDragon check tabbar vs active split colors...

" --- FUTURE EXPANSION SNIPPETS --- "
" "set <F7> to compile and execute
" map <F7> :call CompileRunGcc()<CR>
" func! CompileRunGcc()
" 	exec "w"
" 	exec "!gcc -g -ansi -Wall -Werror % -o %:r"
" 	exec "!./%:r"
" endfunc

" "set <F10> to compile make
" map <F10> : call CompileMake()<CR>
" func! CompileMake()
"         exec "w"
"         exec "!make clean"
"         exec "!make"
" endfunc

"autocmd BufEnter * colorscheme busierbee "default color scheme
"autocmd BufEnter *.c,*.cc,*.cpp*.h colorscheme BusyBee

" }}}

