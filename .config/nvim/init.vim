" vim:foldenable:foldmethod=marker:foldlevel=0


" strip whitespace fn
" 'mileszs/ack.vim'
" tabular
" http://tnerual.eriogerg.free.fr/vimqrc.html








" Plug {{{

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
    Plug 'arcticicestudio/nord-vim'
    Plug 'cocopon/iceberg.vim'
    Plug 'one-dark/onedark.nvim'
    Plug 'rakr/vim-one'
    Plug 'romainl/Apprentice'
    Plug 'rakr/vim-two-firewatch'
    Plug 'dracula/vim'
    Plug 'AlexvZyl/nordic.nvim'
    Plug 'EdenEast/nightfox.nvim'
    " Syntax Highlighting
    Plug 'sheerun/vim-polyglot'
    Plug 'gabrielelana/vim-markdown'
    " Misc
    Plug 'sjl/gundo.vim'
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
    silent! colorscheme nord                        " with a true color colorscheme if available
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


" More Plugins
" tcomment / NERD_commenter

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

