" Change mapleader
let mapleader=","

" Move more naturally up/down when wrapping is enabled.
nnoremap j gj
nnoremap k gk

" Local dirs
if !has('win32')
  set backupdir=$DOTFILES/caches/vim
  set directory=$DOTFILES/caches/vim
  set undodir=$DOTFILES/caches/vim
  let g:netrw_home = expand('$DOTFILES/caches/vim')
endif

" Create vimrc autocmd group and remove any existing vimrc autocmds,
" in case .vimrc is re-sourced.
augroup vimrc
  autocmd!
augroup END

" Theme / Syntax highlighting

" Make invisible chars less visible in terminal.
autocmd vimrc ColorScheme * :hi NonText ctermfg=236
autocmd vimrc ColorScheme * :hi SpecialKey ctermfg=236
" Show trailing whitespace.
autocmd vimrc ColorScheme * :hi ExtraWhitespace ctermbg=red guibg=red
" Make selection more visible.
autocmd vimrc ColorScheme * :hi Visual guibg=#00588A
autocmd vimrc ColorScheme * :hi link multiple_cursors_cursor Search
autocmd vimrc ColorScheme * :hi link multiple_cursors_visual Visual

let g:molokai_italic=0
colorscheme molokai
set background=dark

" Visual settings
set cursorline " Highlight current line
set number " Enable line numbers.
set showtabline=2 " Always show tab bar.
set relativenumber " Use relative line numbers. Current line is still in status bar.
set title " Show the filename in the window titlebar.
set nowrap " Do not wrap lines.
set noshowmode " Don't show the current mode (airline.vim takes care of us)
set laststatus=2 " Always show status line

" Show absolute numbers in insert mode, otherwise relative line numbers.
autocmd vimrc InsertEnter * :set norelativenumber
autocmd vimrc InsertLeave * :set relativenumber

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Scrolling
set scrolloff=3 " Start scrolling three lines before horizontal border of window.
set sidescrolloff=3 " Start scrolling three columns before vertical border of window.

" Indentation
set autoindent " Copy indent from last line when starting new line.
set shiftwidth=2 " The # of spaces for indenting.
set smarttab " At start of line, <Tab> inserts shiftwidth spaces, <Bs> deletes shiftwidth spaces.
set softtabstop=2 " Tab key results in 2 spaces
set tabstop=2 " Tabs indent only 2 spaces
set expandtab " Expand tabs to spaces

" Reformatting
set nojoinspaces " Only insert single space after a '.', '?' and '!' with a join command.

" Toggle show tabs and trailing spaces (,c)
if has('win32')
  set listchars=tab:>\ ,trail:.,eol:$,nbsp:_,extends:>,precedes:<
else
  set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_,extends:>,precedes:<
endif
"set listchars=tab:>\ ,trail:.,eol:$,nbsp:_,extends:>,precedes:<
"set fillchars=fold:-
nnoremap <silent> <leader>v :call ToggleInvisibles()<CR>

" Extra whitespace
autocmd vimrc BufWinEnter * :2match ExtraWhitespaceMatch /\s\+$/
autocmd vimrc InsertEnter * :2match ExtraWhitespaceMatch /\s\+\%#\@<!$/
autocmd vimrc InsertLeave * :2match ExtraWhitespaceMatch /\s\+$/

" Toggle Invisibles / Show extra whitespace
function! ToggleInvisibles()
  set nolist!
  if &list
    hi! link ExtraWhitespaceMatch ExtraWhitespace
  else
    hi! link ExtraWhitespaceMatch NONE
  endif
endfunction

set nolist
call ToggleInvisibles()

" Trim extra whitespace
function! StripExtraWhiteSpace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction
noremap <leader>ss :call StripExtraWhiteSpace()<CR>

" Search / replace
set gdefault " By default add g flag to search/replace. Add g to toggle.
set hlsearch " Highlight searches
set incsearch " Highlight dynamically as pattern is typed.
set ignorecase " Ignore case of searches.
set smartcase " Ignore 'ignorecase' if search pattern contains uppercase characters.

" Clear last search
map <silent> <leader>/ <Esc>:nohlsearch<CR>

" Ignore things
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*/bower_components/*,*/node_modules/*
set wildignore+=*/vendor/*,*/.git/*,*/.hg/*,*/.svn/*,*/log/*,*/tmp/*

" Vim commands
set hidden " When a buffer is brought to foreground, remember undo history and marks.
set report=0 " Show all changes.
set mouse=a " Enable mouse in all modes.
set shortmess+=I " Hide intro menu.

" Splits
set splitbelow " New split goes below
set splitright " New split goes right

" Ctrl-J/K/L/H select split
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

" Buffer navigation
nnoremap <leader>b :CtrlPBuffer<CR> " List other buffers
map <leader><leader> :b#<CR> " Switch between the last two files
map gb :bnext<CR> " Next buffer
map gB :bprev<CR> " Prev buffer

" Jump to buffer number 1-9 with ,<N> or 1-99 with <N>gb
let c = 1
while c <= 99
  if c < 10
    execute "nnoremap <silent> <leader>" . c . " :" . c . "b<CR>"
  endif
  execute "nnoremap <silent> " . c . "gb :" . c . "b<CR>"
  let c += 1
endwhile

" Fix page up and down
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>

" Use Q for formatting the current paragraph (or selection)
" vmap Q gq
" nmap Q gqap

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" When editing a file, always jump to the last known cursor position. Don't do
" it for commit messages, when the position is invalid, or when inside an event
" handler (happens when dropping a file on gvim).
autocmd vimrc BufReadPost *
  \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" F12: Source .vimrc & .gvimrc files
nmap <F12> :call SourceConfigs()<CR>

if !exists("*SourceConfigs")
  function! SourceConfigs()
    let files = ".vimrc"
    source $MYVIMRC
    if has("gui_running")
      let files .= ", .gvimrc"
      source $MYGVIMRC
    endif
    echom "Sourced " . files
  endfunction
endif

"" FILE TYPES

" vim
autocmd vimrc BufRead .vimrc,*.vim set keywordprg=:help

" markdown
autocmd vimrc BufRead,BufNewFile *.md set filetype=markdown


" PLUGINS

" Airline
"let g:airline_powerline_fonts = 1 " TODO: detect this?
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#buffer_nr_format = '%s '
"let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline#extensions#tabline#fnamecollapse = 0
"let g:airline#extensions#tabline#fnamemod = ':t'

" NERDTree
"let NERDTreeShowHidden = 1
"let NERDTreeMouseMode = 2
"let NERDTreeMinimalUI = 1
"map <leader>n :NERDTreeToggle<CR>
"autocmd vimrc StdinReadPre * let s:std_in=1
" If no file or directory arguments are specified, open NERDtree.
" If a directory is specified as the only argument, open it in NERDTree.
"autocmd vimrc VimEnter *
"  \ if argc() == 0 && !exists("s:std_in") |
"  \   NERDTree |
"  \ elseif argc() == 1 && isdirectory(argv(0)) |
"  \   bd |
"  \   exec 'cd' fnameescape(argv(0)) |
"  \   NERDTree |
"  \ end

" Signify
let g:signify_vcs_list = ['git', 'hg', 'svn']

" CtrlP.vim
map <leader>p <C-P>
map <leader>r :CtrlPMRUFiles<CR>
"let g:ctrlp_match_window_bottom = 0 " Show at top of window

" Indent Guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" Mustache/handlebars
let g:mustache_abbreviations = 1

" https://github.com/junegunn/vim-plug
" Reload .vimrc and :PlugInstall to install plugins.
call plug#begin('~/.vim/plugged')
Plug 'bling/vim-airline'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'nathanaelkane/vim-indent-guides'
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'mhinz/vim-signify'
Plug 'mattn/emmet-vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'chase/vim-ansible-yaml'
Plug 'wavded/vim-stylus'
Plug 'klen/python-mode', {'for': 'python'}
Plug 'terryma/vim-multiple-cursors'
Plug 'wting/rust.vim', {'for': 'rust'}
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                             " Be vImproved
set backspace=indent,eol,start               " Allow backspacing over everything in insert mode
set undofile                                 " Save undo's after file closes
set undodir=~/.vim/undo                      " Directory for undo histories
set undolevels=1000                          " How many undos
set undoreload=10000                         " Number of lines to save for undo
set shellcmdflag=-ic                         " Make Vim's :! shell act like your user login shell
set history=1000                             " Keep 1000 lines of command line history
set ruler                                    " Always show the cursor position
set number                                   " Show line numbers
set backup                                   " Keep backups
set backupdir=~/.vim/tmp           " Keep them in this dir
set directory=~/.vim/tmp           " Also keep swap files there
set autochdir                                " Make the working directory the directory of the current file
set ignorecase smartcase                     " Ignore case when searching except if capitalization is used
set guifont=andale_mono:h14                  " Use this font
set guioptions-=T                            " In case I'm using gvim, remove toolbar
set guioptions-=m                            " And menu bar
set columns=180                              " Fits well on Retina
set lines=50                                 " Pretty tall too
"set cindent
set autoindent
set smartindent                              " Indent for me please
set incsearch                                " Highlight matches when beginning to search
set hlsearch                                 " Turn on highlighting the last used search pattern
set showmatch                                " Match parentheses, curly braces, etc.
set showcmd                                  " Display available commands
set wildmode=longest,list                    " Use tab completion when selecting files, etc
set wildmenu                                 " Make tab completion for files/buffers act like bash
set linebreak                                " Wrap lines at convenient points
set foldmethod=indent                        " Fold based on indent
set foldnestmax=3                            " Deepest fold is 3 levels
set nofoldenable                             " Dont fold by default

syntax on                                    " Enable syntax highlighting
filetype plugin indent on                    " Enable file type detection using default settings, load indent files and do language-dependent indenting
:colorscheme molokai                         " Torte " Ah, the colors luke, the colors!
                                             " But use vividchalk for ruby
autocmd! BufEnter,BufNewFile *.rb,*.erb colorscheme vividchalk
autocmd! BufRead,BufNewFile *.es6 setfiletype javascript "set es6 files as JavaScript
autocmd! BufRead,BufNewFile *.jsx,.jsx6 setfiletype javascript "set jsx using es6 files as JavaScript

"set noexpandtab smarttab                       " Smart tabs
" Use spaces instead of tabs (as per company policy)
set expandtab tabstop=4 shiftwidth=4 softtabstop=4     " Tab uses 4 characters
"retab! 4                                     " Auto convert any 4 spaces into a tab

" Use tabs for Ruby
autocmd! BufEnter,BufNewFile *.rb,*.erb set noexpandtab smarttab
autocmd! BufEnter,BufNewFile *.rb,*.erb set tabstop=2 shiftwidth=2 softtabstop=2
"autocmd! BufEnter,BufNewFile *.rb,*.erb retab! 2

" Run Pathogen plugin (easy plugin management)
call pathogen#infect()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key Mappings
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Double-semicolon performs a global search-and-replace with confirmation.
noremap ;; :%s```cg<Left><Left><Left><Left>

" You never type jk in insert mode anyway, so map it to Esc.
inoremap jk <Esc>l

" Swap quote with backtick in normal mode since backtick takes into account the column.
nnoremap ' `
nnoremap ` '

" Swap quote for double quotes, since I like variable interpolation in
" languages but hate pressing shift to get double quotes.
"inoremap ' "
"inoremap " '

" [B]last matching braces!
nnoremap <silent> b %x``x

" F2 removes all empty lines.
inoremap <F2> <Esc>:%s`^\s*$\n``g<CR>
noremap <F2> <Esc>:%s`^\s*$\n``g<CR>

" F3 removes any whitespace at the beginning of lines.
inoremap <F3> <Esc>:%s`^\s\+``g<CR>
noremap <F3> <Esc>:%s`^\s\+``g<CR>

" F4 removes any whitespace at the end of lines.
inoremap <F4> <Esc>:%s`\s\+$``g<CR>
noremap <F4> <Esc>:%s`\s\+$``g<CR>

" Drop up or down a line even if line wraps. Also move by words.
nnoremap <silent> k gk
nnoremap <silent> j gj
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja
"nnoremap <silent> l w
"nnoremap <silent> h b

" Spacebar toggles fold under cursor.
"nnoremap <space> za

" Capital F unfolds everything.
nnoremap F zi

" Toggle search highlighting.
nnoremap \h :set hlsearch!<CR>

" Toggle text wrapping.
nnoremap \w :setlocal wrap!<CR>:setlocal wrap?<CR>

" Switch to new buffer when vertical splitting.
noremap :vs :vsplit<cr><c-w>l

" Easily resize current split.
nnoremap <c-j> :res +10<cr>
nnoremap <c-k> :res -10<cr>
nnoremap <c-h> :vertical res -10<cr>
nnoremap <c-l> :vertical res +10<cr>

" Allow alternation to 2-spaced or 4-spaced indentation styles.
nnoremap \t :set noexpandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>
nnoremap \T :set noexpandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>

"Shortcut for reversing lines in a file.
command Sort g/^/m0

" Shortcuts, and cancelled shortcuts.
" Shortcut for console.log.
ab log console.log
ab clog log

" Shortcut for var_dump in php.
ab vd var_dump);<left><left>
ab die echo '<pre>';die(var_dump,'/* @echo LAST_UPDATE_TIME */'));<left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left>
ab diea die
ab print echo '<pre>';print(var_dump));<left><left><left>
ab printa print
ab btrace echo '<pre>';die(var_dump(debug_print_backtrace()));
ab os OpenSession

" Fix my favorite typo.
ab functino function
ab fn function() {}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Windoze-like Utilities and Compatibility
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fix compatibility issue between yanks and clipboard.
behave mswin

" Ctrl-C is Copy
vnoremap <C-C> "+y

" Ctrl-X is Cut
vnoremap <C-X> "+x

" Ctrl-V is Paste
map <C-V>        "+gP
cmap <C-V>        <C-R>+

" Ctrl-Q is the new Ctrl-V
noremap <C-Q>        <C-V>

" Ctrl-Z is Undo
inoremap <C-Z> <C-O>u
map <C-Z> u

" Ctrl-Y is like Ctrl-R
noremap <C-Y> <C-R>
inoremap <C-Y> <C-O><C-R>
exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

" Ctrl-S saves
noremap <C-S>        :update<CR>
vnoremap <C-S>        <C-C>:update<CR>
inoremap <C-S>        <C-O>:update<CR>

" Ctrl-A selects all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG

" Ctrl-W works regardless of mode
noremap <C-W> <C-W>w
inoremap <C-W> <C-O><C-W>w
cnoremap <C-W> <C-C><C-W>w
onoremap <C-W> <C-C><C-W>w

" Ctrl-F4 is close window
noremap <C-F4> <C-W>c
inoremap <C-F4> <C-O><C-W>c
cnoremap <C-F4> <C-C><C-W>c
onoremap <C-F4> <C-C><C-W>c


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin/Language Specific Options
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" InteractiveReplace (my plugin!)
let g:InteractiveReplace_map = '<leader>r'

" CoffeeScript
nnoremap \c :CoffeeCompile watch vert<CR>
nnoremap \C :CoffeeCompile unwatch<CR>

"vim-spacebars
let g:mustache_abbreviations = 1

" NERDTree
"noremap \\ :NERDTreeToggle<cr>
"let NERDTreeQuitOnOpen=1

" Ctrl-P 
" (call it \\ now!)
nnoremap \\ :CtrlP<CR>
let g:ctrlp_custom_ignore = '\v\~$|node_modules|build|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 'ET'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
    \ }
"let g:ctrlp_dotfiles = 0

" Oldschool Powerline
let g:Powerline_symbols = 'fancy'
set laststatus=2

" Autoload sessions using vim-session.
let g:session_autoload='yes'
let g:session_autosave='yes'
let g:session_autosave_periodic=5

" Default consideration in megabytes for a 'large file'.
"let g:LargeFile = 100
:source ~/.vim/plugin/LargeFile.vim

" JavaScript indenting
let g:js_indent_log = 0

" Tim Pope's ragtag.
let g:ragtag_global_maps = 1 

" Closetag.vim
:let g:closetag_html_style=1
if !exists('b:unaryTagsStack') || exists('b:closetag_html_style')
  if &filetype == 'html' || exists('b:closetag_html_style')
    let b:unaryTagsStacktack='area base br dd dt hr img input link meta param'
  else " for xml and xsl
    let b:unaryTagsStack=''
  endif
endif
if !exists('b:unaryTagsStack')
  let b:unaryTagsStack=''
endif
:source ~/.vim/plugin/closetag.lasttag.vim


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocommands
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto retab when saving.
"au BufWrite * silent retab!

" Automatically cd into the directory that the file is in.
au BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

" Define a compilation dir where CoffeeScript, HAML, Sass, etc. will be automatically compiled (default: parent directory).
" Also define a key to easily switch directories. Use vim's tmp directory to effectively turn this feature off.
let compilation_dir = 'none'
nnoremap <silent> \d :exe "if compilation_dir=='/../' \| let compilation_dir='/.' \| elseif compilation_dir=='/.' \| let compilation_dir='none' \| elseif compilation_dir=='none' \| let compilation_dir='dist' \| else \| let compilation_dir = '/../' \| endif \| echo 'Compilation dir: '.compilation_dir"<CR>

" Autocompile CoffeeScript on save with CoffeeMake 
let coffee_compiler = "/usr/local/share/npm/bin/coffee"
au BufWritePost *.coffee if compilation_dir!="none" | silent execute 'CoffeeMake! -o '.expand('<afile>:p:h').compilation_dir | endif | cwindow | redraw!

" Autocompile HAML on save with haml.
au BufWritePost *.haml if compilation_dir!="none" | silent execute '!haml --trace '.expand('<afile>:p:t').' '.expand('<afile>:p:r').'.html' | cwindow | redraw!

" Autocompile SASS on save with sass.
au BufWritePost *.sass,*.scss if compilation_dir!="none" | silent execute '!sass --trace '.compilation_dir.expand('<afile>:p:t').' > '.compilation_dir.expand('<afile>:p:r').'.css' | cwindow | redraw!

" Remove any trailing whitespace that is in the file when you save.
function! <SID>StripTrailingWhitespaces()
" Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction
"au BufWrite *.js,*.coffee,*.css,*.sass,*.html,*.haml,*.rb,*.php,*.cf,*.cs :call <SID>StripTrailingWhitespaces()

au BufRead *.tpl,*.hbt :set filetype=html
au BufRead *.less :set filetype=css

" Restore cursor position to where it was prior to quitting.
augroup JumpCursorOnEdit
   au!
   autocmd BufReadPost *
            \ if expand("<afile>:p:h") !=? $TEMP |
            \   if line("'\"") > 1 && line("'\"") <= line("$") |
            \     let JumpCursorOnEdit_foo = line("'\"") |
            \     let b:doopenfold = 1 |
            \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
            \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
            \        let b:doopenfold = 2 |
            \     endif |
            \     exe JumpCursorOnEdit_foo |
            \   endif |
            \ endif
" Need to postpone using "zv" until after reading the modelines.
   autocmd BufWinEnter *
            \ if exists("b:doopenfold") |
            \   exe "normal zv" |
            \   if(b:doopenfold > 1) |
            \       exe  "+".1 |
            \   endif |
            \   unlet b:doopenfold |
            \ endif
augroup END

"match ErrorMsg '\%>120v.\+'                   " Warn if a line is more than 80 characters


