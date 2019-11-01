scriptencoding utf-8

augroup nvimrc
	autocmd!
augroup END

set shell=bash\ -i

" INITIALIZE PLUG {{{ ==========================================================================================
"----------------------------------------------------------------------------------------------------------------------"
"                                                    INITIALIZE PLUG                                                   "
"----------------------------------------------------------------------------------------------------------------------"
if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd nvimrc VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" General {{{ -------------------------------------------------------------------------------------------------
Plug 'airblade/vim-rooter'                               " Changes Vim working directory to project root
Plug 'alvan/vim-closetag'                                " Auto close (X)HTML tags
Plug 'bronson/vim-visual-star-search'                    " Start a * or # search from a visual block
Plug 'chrisbra/csv.vim'                                  " A Filetype plugin for csv files
Plug 'christoomey/vim-tmux-navigator'                    " Seamless navigation between tmux panes and vim splits
Plug 'csscomb/vim-csscomb', { 'do': 'npm i -g csscomb' } " Tool for sorting CSS properties in specific order
Plug 'easymotion/vim-easymotion'                         " Vim motion on speed
Plug 'editorconfig/editorconfig-vim'                     " This is an EditorConfig plugin for Vim
Plug 'edkolev/tmuxline.vim'                              " tmux statusline (airline) generator: powerline symbols
Plug 'ervandew/supertab'                                 " allows you to use <Tab> for all your insert completion needs
Plug 'farmergreg/vim-lastplace'                          " Intelligently reopen files at your last edit position
Plug 'godlygeek/tabular'                                 " for text filtering and alignment
Plug 'honza/vim-snippets'                                " contains snippets files for various programming languages
Plug 'jiangmiao/auto-pairs'                              " insert or delete brackets, parens, quotes in pairs
Plug 'jtbairdsr/vim-center-comment'                      " for formatting comments to center
Plug 'kshenoy/vim-signature'                             " Plugin to toggle, display and navigate marks
Plug 'mhinz/vim-signify'                                 " shows a VCS diff in the sign column
Plug 'michaeljsmith/vim-indent-object'                   " defines text object for lines of code with same indent level
Plug 'mileszs/ack.vim'                                   " run ack (or ag) from Vim
Plug 'ntpeters/vim-better-whitespace'                    " Better whitespace highlighting
Plug 'scrooloose/nerdcommenter'                          " intensely orgasmic commenting
Plug 'shougo/denite.nvim',                               " Dark powered asynchronous: unite all interfaces Neovim/Vim8
Plug 'sirver/ultisnips'                                  " the ultimate snippet solution for Vim
Plug 'sjl/gundo.vim'                                     " visualize your Vim undo tree
Plug 'svermeulen/vim-easyclip'                           " Simplified clipboard functionality for Vim
Plug 'terryma/vim-multiple-cursors'                      " attempt at Sublime Text's multiple selection feature
Plug 'tmux-plugins/vim-tmux-focus-events'                " restores FocusGained/FocusLost autocommand events inside Tmux
Plug 'tpope/vim-abolish'                                 " find, substitute, and abbreviate multiple variants of a word
Plug 'tpope/vim-fugitive'                                " git of the gods plugin
Plug 'tpope/vim-obsession'                               " continuously updated session files
Plug 'tpope/vim-repeat'                                  " enable repeating supported plugin maps with '.'
Plug 'tpope/vim-sleuth'                                  " automatically adjusts 'shiftwidth' and 'expandtab'
Plug 'tpope/vim-speeddating'                             " use CTRL-A/CTRL-X to increment dates, times, and more
Plug 'tpope/vim-surround'                                " provides mappings to delete, change and add surrounding pairs
Plug 'tpope/vim-unimpaired'                              " pairs of handy bracket mappings
Plug 'triglav/vim-visual-increment'                      " increasing sequence of numbers or letters via visual mode
Plug 'valloric/MatchTagAlways'                           " always highlights the enclosing html/xml tags
Plug 'vim-airline/vim-airline'                           " Lean & mean status/tabline for vim that's light as air.
Plug 'vim-airline/vim-airline-themes'                    " A collection of themes for vim-airline
Plug 'vim-scripts/bufexplorer.zip'                       " quickly and easily switch between buffers
Plug 'vim-scripts/searchcomplete'                        " tab-complete words while typing in a search
Plug 'vim-scripts/text-object-left-and-right'            " create text object for left and right of a statement
Plug 'w0rp/ale'                                          " Asynchronous Lint Engine
Plug 'wellle/targets.vim'                                " provides additional text objects
Plug 'wellle/visual-split.vim'                           " control splits with visual selections or text objects
Plug 'yggdroot/indentLine'                               " display the indention levels with thin vertical lines
Plug 'zhaocai/GoldenView.Vim'                            " Always have a nice view for vim split windows
Plug 'machakann/vim-highlightedyank'                     " Make the yanked region apparent!
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'chiel92/vim-autoformat', { 'do': 'npm i -g js-beautify remark-cli fixjson xo typescript-formatter' }
Plug 'rrethy/vim-illuminate'                             " selectively highlight other uses of the word under the cursor
Plug 'sbdchd/neoformat'                                  " for formatting code
Plug 'junegunn/gv.vim'                                   " A git commit browser in Vim
Plug 'eugen0329/vim-esearch'                             " Perform search in files easily
Plug 'andrewradev/splitjoin.vim'                         " simplifies swapping between multiline and single-line code
Plug 'junegunn/vim-easy-align'                           " A simple, easy-to-use alignment plugin
Plug 'majutsushi/tagbar'                                 " displays tags in a window, ordered by scope
Plug 'konfekt/fastfold'                                  " Speed up Vim by updating folds only when called-for
Plug 'sjl/vitality.vim'                                  " Make Vim play nicely with iTerm 2 and tmux
Plug 'junegunn/goyo.vim'                                 " Distraction-free writing in Vim
Plug 'tpope/vim-dispatch'                                " Asynchronous build and test dispatcher
Plug 'heavenshell/vim-jsdoc'
Plug 'pedrohdz/vim-yaml-folds'                           " YAML, RAML, EYAML & SaltStack SLS folding
" Plug 'shmargum/vim-sass-colors'                          " plugin with sass/scss color variable highlighting (works with imports)
" }}} End General

" Syntax Highlighting {{{ -------------------------------------------------------------------------------------
Plug 'cakebaker/scss-syntax.vim'              " syntax file for scss
Plug 'chr4/nginx.vim'                         " Improved nginx vim plugin (incl. syntax highlighting)
Plug 'herringtondarkholme/yats.vim'           " The most advanced TypeScript Syntax Highlighting
" Plug 'leshill/vim-json'                       " Syntax highlighting for JSON
Plug 'elzr/vim-json'                          " A better JSON:  distinct highlighting of keywords vs values
Plug 'othree/yajs.vim'                        " Yet Another JavaScript Syntax
Plug 'othree/es.next.syntax.vim'              " ES.Next syntax for Vim
Plug 'othree/javascript-libraries-syntax.vim' " Syntax files for JavaScript libraries (underscore angular etc.)
Plug 'plasticboy/vim-markdown'                " Syntax highlighting, matching rules and mappings for Markdown
Plug 'tmux-plugins/vim-tmux'                  " proper syntax highlighting etc.
Plug 'wgwoods/vim-systemd-syntax'             " Syntax highlighting for systemd service files
Plug 'pangloss/vim-javascript'                " Yet Another JavaScript Syntax for Vim
Plug 'nikvdp/ejs-syntax'                      " syntax highlighting for javascript EJS html templates
Plug 'digitaltoad/vim-pug'                    " Pug (formerly Jade) template engine syntax highlighting and indention
Plug 'hail2u/vim-css3-syntax'                 " CSS3 syntax
Plug 'othree/html5.vim'                       " HTML5 omnicomplete and syntax
Plug 'cespare/vim-toml'                       " syntax for TOML
Plug 'maralla/vim-toml-enhance'               " vim-toml syntax color enhancement

" WARNING: This breaks TypeScript syntax highlighting.
" Plug 'maxmellon/vim-jsx-pretty'               " React JSX syntax highlighting and indenting for vim.
" }}} End Syntax Highlighting

" LanguageClient {{{ ------------------------------------------------------------------------------------------
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
" }}}

" Deoplete {{{ ------------------------------------------------------------------------------------------------
Plug 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }    " asynchronous keyword completion system
Plug 'tenfyzhong/CompleteParameter.vim'                          " Complete parameter after select the completion
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' } " enables tern completions
" Plug 'shougo/neco-syntax'                                        " Syntax source for neocomplete/deoplete/ncm
Plug 'shougo/deoplete-zsh'                                       " Zsh completion for deoplete.nvim
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}       " Typescript tooling for Neovim
Plug 'wellle/tmux-complete.vim'                                  " insert mode completion of words in other tmux panes
Plug 'quramy/vison'                                              " for writing JSON with JSON Schema
" Plug 'shougo/neco-vim'                                           " vim completions for deoplete
" Plug 'shougo/neoinclude.vim'                                     " include completion framework for deoplete
Plug 'dnitro/vim-pug-complete', {'for': ['jade', 'pug']}         " omni-completion support for pug
" }}} End Deoplete

" NERDTree {{{ ------------------------------------------------------------------------------------------------
Plug 'albfan/nerdtree'                         " allows you to explore your filesystem and open files/directories.
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " this adds syntax for nerdtree on most common file extensions.
Plug 'scrooloose/nerdtree-project-plugin'      " proof of concept for nerdtree projects
Plug 'albfan/nerdtree-git-plugin'              " makes NERDTree show git status flags
Plug 'octref/RootIgnore'                       " Set wildignore from git repo root
Plug 'EvanDotPro/nerdtree-chmod'               " A plugin for NERDTree that allows for chmod'ing files.
" }}} End NERDTree

" Color schemes {{{ -------------------------------------------------------------------------------------------
Plug 'lifepillar/vim-solarized8'        " Optimized Solarized colorschemes. Best served with true-color terminals!
Plug 'blueyed/vim-diminactive'          " dim inactive windows
Plug 'altercation/vim-colors-solarized' " precision colorscheme
" }}} End Color schemes

" Conquer of Completion {{{ -------------------------------------------------------------------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" }}} End Color schemes

" !!!MUST BE LOADED LAST!!! {{{ -------------------------------------------------------------------------------
" Plug 'ryanoasis/vim-devicons' " Adds file type glyphs/icons to NERDTree, vim-airline, and others
" }}} End Color schemes

call plug#end()
" }}} END INITIALIZE PLUG

" PLUGIN SETTINGS {{{ ==========================================================================================
"----------------------------------------------------------------------------------------------------------------------"
"                                                  Plugin Settings                                                     "
"----------------------------------------------------------------------------------------------------------------------"
" ------------ ACK ----------- {{{ - bundle name: mileszs/ack.vim ----------------------------------------------
if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

let g:ag_working_path_mode = 'r'
" }}} End ACK

" ---------- eSearch --------- {{{ - bundle name: eugen0329/vim-esearch ----------------------------------------
let g:esearch = {
  			\ 'adapter':    'ag',
  			\ 'backend':    'nvim',
  			\ 'out':        'qflist',
  			\ 'batch_size': 1000,
  			\ 'use':        ['visual', 'hlsearch', 'last', 'clipboard', 'system_clipboard', 'word_under_cursor'],
  			\}
" }}} End ACK

" ---------- Airline --------- {{{ - bundle names: vim-airline/vim-airline, vim-airline-themes -----------------
let g:airline_powerline_fonts  = 1
let g:virtualenv_auto_activate = 1

" set laststatus=2

let g:airline#extensions#tabline#enabled              = 1
let g:airline#extensions#tabline#tab_nr_type          = 1
let g:airline#extensions#tabline#fnamemod             = ':t'
let g:airline#extensions#tmuxline#enabled             = 0
let g:airline#extensions#virtualenv#enabled           = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 2

if exists('colorchange')
	let g:airline#extensions#tmuxline#enabled = 1
endif
" }}} End Airline

" ------------ ALE ----------- {{{ - bundle name: w0rp/ale -----------------------------------------------------
let g:ale_fix_on_save                = 1   " fix files automatically on save.
let g:ale_completion_enabled         = 0   " Enable completion where available.
let g:ale_sign_column_always         = 1   " keep the sign gutter open always
let g:ale_set_quickfix               = 0   " use the quckfix window
let g:ale_sign_error                 = '' " change the error sign
let g:ale_sign_error                 = '' " change the error sign
let g:ale_sign_warning               = '' " change the warning sign
let g:airline#extensions#ale#enabled = 1   " add to status line...
" let g:ale_open_list                  = 1 " open quickfix window when there are errors

" After this is configured, :ALEFix will try and fix your JS code with ESLint.
let g:ale_fixers = {
			\ 'javascript': ['eslint'],
			\ 'typescript': ['tslint'],
			\ }

let g:ale_linters = {
			\ 'html': ['HTMLHint', 'proselint'],
			\ 'dockerfile': ['hadolint'],
			\ 'javascript': ['eslint', 'flow', 'prettier'],
			\ 'typescript': ['tsserver', 'tslint'],
			\ 'css': ['stylelint'],
			\ 'scss': ['stylelint', 'prettier'],
			\ 'yaml': ['yamllint', 'swaglint'],
			\ 'text': ['proselint'],
			\ 'textinfo': ['proselint'],
			\ 'sql': ['sqlint'],
			\ 'vim': ['vint'],
			\ 'vim help': ['proselint'],
			\ 'mardown': ['proselint', 'mdl'],
			\ 'json': ['jsonlint', 'prettier'],
			\ 'bash': ['shellcheck', 'shell -n flag'],
			\ 'bourne shell': ['shellcheck', 'shell -n flag'],
			\ 'pug': ['puglint'],
			\ }

nmap <silent><Leader>aj <Plug>(ale_next)
nmap <silent><Leader>aJ <Plug>(ale_last)
nmap <silent><Leader>ak <Plug>(ale_previous)
nmap <silent><Leader>aK <Plug>(ale_first)
" }}} End ALE

" -------- Autoformat -------- {{{ - bundle name: chiel92/vim-autoformat ---------------------------------------
" map format to <F3>
noremap <F3> :Autoformat<CR>
" format file on save
au nvimrc  FileType                  yaml,vim,css  let b:autoformat_autoindent = 0
au nvimrc  FileType                  yaml,css      let b:autoformat_retab      = 0
" au nvimrc  BufWritePre,FileWritePre  *             :Autoformat
" }}} End Autoformat

" ------- Color Schemes ------ {{{ - bundle name: flazz/vim-colorschemes ---------------------------------------
set background=light
colorscheme solarized8_high " a nice color scheme
let g:solarized_termtrans       = 1
let g:solarized_visibility      = 'low'
let g:solarized_contrast        = 'high'
let g:solarized_diffmode        = 'high'
let g:solarized_term_italics    = 1
let g:solarized_extra_hi_groups = 1
let g:solarized_statusline      = 'low'

let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors


" create a mapping that lets me change from light to dark on the fly
call togglebg#map('<F1>')
" }}} End Color Schemes

" ----- CompleteParameter ---- {{{ - bundle name: tenfyzhong/CompleteParameter.vim -----------------------------
inoremap <silent><expr> ( complete_parameter#pre_complete("()")
smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
imap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
" }}} CompleteParameter

" -------- CSS3 Syntax ------- {{{ - bundle name: hail2u/vim-css3-syntax -----------------------------------
autocmd FileType css setlocal iskeyword+=-
" }}} End CSScomb

" ---------- CSScomb --------- {{{ - bundle name: danhodos/vim-comb --------------------------------------------
" Automatically comb your CSS on save
autocmd nvimrc BufWritePre,FileWritePre *.css,*.less,*.sass silent! :call CSScomb()
autocmd nvimrc FileType *.css nnoremap <buffer> <F6> :call CSScomb()<CR>

function! CSScomb()
	execute 'silent !csscomb '.expand('%')
	redraw!
endfunction
" }}} End CSScomb

" --------- Deoplete --------- {{{ - bundle name: shougo/deoplete.nvim -----------------------------------------
let g:deoplete#enable_at_startup = 1
" }}} End Deoplete

" --------- DevIcons --------- {{{ - bundle name: ryanoasis/vim-devicons ---------------------------------------
let g:webdevicons_conceal_nerdtree_brackets        = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth           = 1
let g:WebDevIconsUnicodeDecorateFolderNodes        = 1 " enable folder/directory glyph flag
let g:DevIconsEnableFoldersOpenClose               = 1 " enable open and close folder/directory glyph flags
let g:DevIconsEnableFolderExtensionPatternMatching = 1 " enable file extension glyphs on folder/directory
" }}} End DevIcons

" --------- EasyClip --------- {{{ - bundle name: svermeulen/vim-easyclip --------------------------------------
let g:EasyClipAutoFormat              = 1
let g:EasyClipShareYanks              = 1
let g:EasyClipShowYanksWidth          = 120
let g:EasyClipUseSubstituteDefaults   = 1
let g:EasyClipUsePasteToggleDefaults  = 0
let g:EasyClipEnableBlackHoleRedirect = 0

set clipboard=unnamed

nmap <Leader>cf <Plug>EasyClipToggleFormattedPaste
" }}} End EasyClip

" -------- EasyMotion -------- {{{ - bundle name: easymotion/vim-easymotion ------------------------------------
map <Space> <Plug>(easymotion-prefix)
" }}}End EasyMotion

" ------- EditorConfig ------- {{{ - bundle name: editorconfig/editorconfig-vim --------------------------------
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
" }}} End EditorConfig

" --------- Fugitive --------- {{{ - bundle name: tpope/vim-fugitive -------------------------------------------
" general mappings
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gl :Glog<CR>
nnoremap <Leader>gd :Gvdiff<CR>
nnoremap <Leader>gp :Dispatch! git push<CR>
nnoremap <Leader>g- :Silent Git stash<CR>:e<CR>
nnoremap <Leader>g+ :Silent Git stash pop<CR>:e<CR>

" diff mappings
nnoremap <Leader>du :diffupdate<CR>
vnoremap do :diffget <bar> diffupdate<CR>
vnoremap dp :diffput <bar> diffupdate<CR>
nnoremap <Leader>dol :diffget //3 <bar> diffupdate<CR>
nnoremap <Leader>doh :diffget //2 <bar> diffupdate<CR>
" }}} End Fugitive

" ------------ FZF ----------- {{{ - bundle name: junegunn/fzf.vim ---------------------------------------------
map <C-Space> :call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached', 'options': '--multi'}))<CR>
" End FZF}}}

" -------- GoldenView -------- {{{ - bundle name: zhaocai/GoldenView.Vim ---------------------------------------
let g:goldenview__enable_default_mapping = 0
let g:goldenview__enable_at_startup      = 0

nmap <Silent> <Leader>tgv <Plug>ToggleGoldenViewAutoResize
" }}} End GoldenView

" ---------- Gundo ----------- {{{ - bundle name: sjl/gundo.vim ------------------------------------------------
nnoremap <F5> :GundoToggle<CR>
" }}} End Gundo

" -------- IndentLine -------- {{{ - bundle name: Yggdroot/indentLine ------------------------------------------
let g:indentLine_setColors             = 0
" let g:indentLine_leadingSpaceEnabled = 1   " mark leading spaces
let g:indentLine_leadingSpaceChar      = '.' " char to mark leading spaces
let g:indentLine_showFirstIndentLevel  = 0
let g:indentLine_concealcursor         = ""

set list lcs=tab:\│\                        "  show tabs
" }}} End IndentLine

" -------- JavaScript -------- {{{ - bundle name: pangloss/vim-javascript --------------------------------------
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
" }}} End Javascript

" Javascript Libraries Syntax  {{{ - bundle name: othree/javascript-libraries-syntax.vim -----------------------
let g:used_javascript_libs = 'underscore,angularjs,jquery'
" }}}

" ----------- JSDoc ---------- {{{ - bundle name: heavenshell/vim-jsdoc-----------------------------------------
let g:jsdoc_allow_input_prompt = 1              " Allow prompt for interactive input
let g:jsdoc_input_description  = 1              " Prompt for a function description
" let g:jsdoc_enable_es6         = 1              " Enable ES6 shorthand function, arrow functions
let g:jsdoc_additional_descriptions = 1         " Prompt for a value for @name, add it to the JSDoc block comment along with the @function tag.
let g:jsdoc_param_description_separator = '   ' " Characters used to separate @param name and description.
let g:jsdoc_custom_args_hook = {
    \    '_req\|req': {
    \        'type': '{Request}',
    \        'description':  'an object that represents the HTTP request and has properties for the request query'.
    \                        'string, parameters, body, HTTP headers, and so on'
    \    },
    \    '_res\|res': {
    \        'type': '{Response}',
    \        'description':  'an object that represents the HTTP response that an Express app sends when it gets an'.
    \                        'HTTP request'
    \    },
    \    'next': {
    \        'type': '{NextFunction}',
    \        'description':  'the callback function that will take us to the next middleware.  If you pass an error it'.
    \                        'will respond to the client with a 500 server error'
    \    },
    \    'callback\|cb': {
    \        'type': '{function}',
    \        'description':  'The callback function.'
    \    }
    \}
let g:jsdoc_type_hook = {
    \    'Sequest': 'an object that represents the HTTP request and has properties for the request query string,'.
    \               'parameters, body, HTTP headers, and so on',
    \    'Response': 'an object that represents the HTTP response that an Express app sends when it gets an HTTP'.
    \                'request',
    \    'NextFunction': 'the callback function that will take us to the next middleware.  If you pass an error it'.
    \                     'will respond to the client with a 500 server error'
    \}

" puts jsdoc above last function
nmap <silent> <Leader>jsd ?function<cr>:noh<cr><Plug>(jsdoc)
" }}} End JSDoc

" -------- JSX-Pretty -------- {{{ - bundle name: maxmellon/vim-jsx-pretty -------------------------------------
let g:vim_jsx_pretty_enable_jsx_highlight = 1
let g:vim_jsx_pretty_colorful_config = 1
" }}} End JSX-Pretty

" ------ LanguageClient ------ {{{ - bundle name: autozimu/LanguageClient-neovim -------------------------------
" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_diagnosticsList = 'Location'
let g:LanguageClient_serverCommands = {
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'sh': ['bash-language-server', 'start']
    \ }

nnoremap <leader>K :call LanguageClient_textDocument_hover()<CR>
" }}}

" ------ NERD-Commenter ------ {{{ - bundle name: scrooloose/nerdcommenter -------------------------------------
" map <F4> to start a new comment while in insert mode
imap <F4> <Plug>NERDCommenterInsert

let g:NERDSpaceDelims            = 1      " Add spaces after comment delimeters by default
let g:NERDCompactSexyComs        = 1      " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign           = 'left' " Align line comments left, don't follow code indentation
let g:NERDCommentEmptyLines      = 1      " Allow commenting empty lines (good for commenting a region)
let g:NERDTrimTrailingWhitespace = 1      " Enable trimming of trailing whitespace when uncommenting
" }}} End NERD-Commenter

" --------- NERD-Tree -------- {{{ - bundle name: scrooloose/nerdtree ------------------------------------------
noremap <Leader>nf    :NERDTreeFind<CR>
noremap <Leader><C-n> :NERDTreeToggle<CR>

let g:NERDTreeWinPos            = 'left' " place nerdtree on the left
let g:NERDTreeQuitOnOpen        = 0      " close the tree when we open a file
let g:NERDTreeAutoDeleteBuffer  = 1      " delete the buffer when NERDTree is used to delete a file...
let g:NERDTreeMinimalUI         = 1      " make it prettier
let g:NERDTreeDirArrows         = 1      " make it prettier
let g:NERDTreeHijackNetrw       = 1      " use nerdtree instead of netrw
let g:NERDTreeRespectWildIgnore = 1      " don't show files/directories in .gitignore

" close the tab if NERDTree is the only window left open
autocmd nvimrc bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" }}} End NERD-Tree

" ------ NERD-Tree Git ------- {{{ - bundle name: xuyuanp/nerdtree-git-plugin ----------------------------------
let g:NERDTreeIgnoredStatus = 1
" }}} End NERD-Tree Git

" NERDTree Syntax Highlighting {{{ - bundle name: tiagofumo/vim-nerdtree-syntax-highlight ----------------------
" Highlight folders using exact match
let g:NERDTreeHighlightFolders         = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
" }}} End NERDTree Syntax Highlighting

" ----- Nvim-Typescript ------ {{{ - bundle name: mhartington/nvim-typescript ----------------------------------
	nmap <silent><Leader>tsg :TSGetCodeFix<CR>
	nmap <silent><Leader>tsi :TSImport<CR>
	nmap <silent><Leader>tsr :TSRename<CR>
" }}} End Nvim-Typescript

" -------- SCSS-Syntax ------- {{{ - bundle name: cakebaker/scss-syntax.vim ------------------------------------
au BufRead,BufNewFile,BufEnter *.scss set filetype=scss.css
au BufRead,BufNewFile,BufEnter *.scss set syntax=scss
" }}} End SCSS-Syntax

" --------- SuperTab --------- {{{ - bundle name: ervandew/supertab --------------------------------------------
let g:SuperTabDefaultCompletionType = "<c-n>"
" }}} End SuperTab

" --------- Tabular ---------- {{{ - bundle name: godlygeek/tabular --------------------------------------------
function! TabMapper(mapping, alignment)
	execute 'map '.a:mapping.' :Tabularize '.a:alignment."<CR>:call repeat#set('".a:mapping."')\<CR>"
endfunction

call TabMapper(',a:', '/:\zs')
call TabMapper(',a=', '/=')
call TabMapper(',a,', '/,\zs')
call TabMapper(',a)', '/)\zs')
call TabMapper(',a}', '/}\zs')
call TabMapper(',af', '/from')

function! MapCommentAlign(commentstring)
	let s:comment = split(a:commentstring, '%s')
	if len(s:comment) == 1
		call TabMapper(',ac', '/^\s*\S.*\zs'.s:comment[0])
	endif
endfunction

" remap this so that it is always buffer specific
autocmd nvimrc BufEnter,BufRead,BufNewFile * call MapCommentAlign(&commentstring)

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

" realtime table builder based on '|' " {{{
function! s:align()
	let s:p = '^\s*|\s.*\s|\s*$'
	if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# s:p || getline(line('.')+1) =~# s:p)
		let s:column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
		let s:position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
		Tabularize/|/l1
		normal! 0
		call search(repeat('[^|]*|',s:column).'\s\{-\}'.repeat('.',s:position),'ce',line('.'))
	endif
endfunction " }}} End align function
" }}} End Tabular

" ------- TaskWarrior -------- {{{ - bundle name: farseer90718/vim-taskwarrior ---------------------------------
let g:task_rc_override = 'rc.defaultwidth=0'
" }}} End TaskWarrior

" --------- TaskWiki --------- {{{ - bundle name: tbabej/taskwiki ----------------------------------------------
let g:taskwiki_source_tw_colors = 'yes'
" }}} End TaskWiki

" --------- TernJS ----------  {{{ - bundle name: carlitux/deoplete-ternjs -------------------------------------
" Set bin if you have many instalations
" let g:deoplete#sources#ternjs#tern_bin = '/path/to/tern_bin'
let g:deoplete#sources#ternjs#timeout = 1

" Whether to include the types of the completions in the result data.
" Default: 0
let g:deoplete#sources#ternjs#types = 1

" Whether to include the distance (in scopes for variables, in prototypes for properties) between the completions and
" the origin position in the result data.
" Default: 0
let g:deoplete#sources#ternjs#depths = 1

" Whether to include documentation strings (if found) in the result data.
" Default: 0
let g:deoplete#sources#ternjs#docs = 1

" When on, only completions that match the current word at the given point will be returned. Turn this off to get all
" results, so that you can filter on the client side.
" Default: 1
let g:deoplete#sources#ternjs#filter = 0

" Whether to use a case-insensitive compare between the current word and potential completions.
" Default 0
let g:deoplete#sources#ternjs#case_insensitive = 1

" When completing a property and no completions are found, Tern will use some heuristics to try and return some
" properties anyway. Set this to 0 to turn that off.
" Default: 1
let g:deoplete#sources#ternjs#guess = 0

" Determines whether the result set will be sorted.
" Default: 1
let g:deoplete#sources#ternjs#sort = 0

" When disabled, only the text before the given position is considered part of the word. When enabled (the default),
" the whole variable name that the cursor is on will be included.
" Default: 1
let g:deoplete#sources#ternjs#expand_word_forward = 0

" Whether to ignore the properties of Object.prototype unless they have been spelled out by at least two characters.
" Default: 1
let g:deoplete#sources#ternjs#omit_object_prototype = 0

" Whether to include JavaScript keywords when completing something that is not a property.
" Default: 0
let g:deoplete#sources#ternjs#include_keywords = 1

" If completions should be returned when inside a literal.
" Default: 1
let g:deoplete#sources#ternjs#in_literal = 1

"Add extra filetypes
let g:deoplete#sources#ternjs#filetypes = [ 'jsx' ]
"  }}}

" --------- Tmuxline --------- {{{ - bundle name: edkolev/tmuxline.vim -----------------------------------------
let g:tmuxline_theme = 'airline'
let g:tmuxline_preset = {
			\ 'a': '#{?client_prefix,PREFIX  ,#{?pane_in_mode, COPY  ,}}#S',
			\ 'b': '#U@#H  #(~/bin/ip-info.sh)',
			\ 'c': '#{cpu_fg_color}#{cpu_percentage} ',
			\ 'win': ['#I', '#W'],
			\ 'cwin': ['#I', '#W'],
			\ 'x': '#{battery_status_fg}#{battery_icon}  #{battery_percentage} #{battery_remain}',
			\ 'y': ' %a %h-%d %H:%M#{?@timer-running,  #(~/bin/bettertouchtool/timer-app/timer-app-manager.sh),}',
			\ 'z': '#(~/bin/now-playing.sh)',
			\ }
" }}} End Tmuxline

" ------ Tmux Complete ----- {{{ - bundle name: wellle/tmux-complete.vim ---------------------------------------
let g:tmuxcomplete#trigger = ''
" }}} End Tmux Complete

" ------ Tmux Navigator ------ {{{ - bundle name: christoomey/vim-tmux-navigator -------------------------------
let g:tmux_navigator_disable_when_zoomed = 1
nmap <BS> :TmuxNavigateLeft<CR>
" }}} End Tmux Navigator

" --------- UltiSnips -------- {{{ - bundle name: SirVer/ultisnips ---------------------------------------------
let g:UltiSnipsExpandTrigger = '<c-e>'
" }}} End UltiSnips

" --------- Vim-JSON --------- {{{ - bundle name: elzr/vim-json ------------------------------------------------

" }}} End Vim-JSON

" ---------- Vison ----------- {{{ - bundle name: Quramy/vison -------------------------------------------------
autocmd BufRead,BufNewFile package.json,.gitlab-ci.yml Vison
" }}} End Vison

" ----- Visual Increment ----- {{{ - bundle name: triglav/vim-visual-increment ---------------------------------
	set nrformats=alpha " lets me increment columns of letters as well as numbers
" }}}

" ---- Visual Star Search ---- {{{ - bundle name: bronson/vim-visual-star-search -------------------------------
" use ag for recursive searching so we don't find 10,000 useless hits inside node_modules
nnoremap <leader>* :call ack#Ack('grep', '--literal ' . shellescape(expand("<cword>")))<CR>
vnoremap <leader>* :<C-u>call VisualStarSearchSet('/', 'raw')<CR>:call ack#Ack('grep', '--literal ' . shellescape(@/))<CR>
" }}} End Visual Star Search
" }}} END PLUGIN SETTINGS

" KEY REMAPPING {{{ ============================================================================================
"----------------------------------------------------------------------------------------------------------------------"
"                                                     Key Remapping                                                    "
"----------------------------------------------------------------------------------------------------------------------"
nnoremap <Leader>ev :tabe $MYVIMRC<CR>   " edit vimrc
nnoremap <Leader>ez :tabe ~/.zshrc<CR>   " edit zshrc
nnoremap <Leader>sv :source $MYVIMRC<CR> " reload vimrc
nnoremap <Leader>s :mksession<CR>        " save session
nnoremap <Leader><Space> :nohlsearch<CR> " turn of search highlight
nnoremap gV `[v`]                        " highlight last inserted text
nnoremap <Leader>zp :tabnew %<CR>        " zoom current pane
" }}} END KEY REMAPPING

" VIM APPEARANCE {{{ ===========================================================================================
"----------------------------------------------------------------------------------------------------------------------"
"                                                    VIM Appearance                                                    "
"----------------------------------------------------------------------------------------------------------------------"
set guifont=Monoid\ Nerd\ Font\ Mono:h12               " this forces the needed font for some of the fancyness
syntax enable                                          " turn on syntax highlighting

au BufNewFile,BufRead,BufEnter *.b,*/*BP*/* setf jbase " enable syntax highlighting for jBASE (Pick) Basic
au BufNewFile,BufRead,BufEnter *.vim setf vim          " enable syntax highlighting for vim config and plugins
au BufNewFile,BufRead,BufEnter *.ejs setf ejs          " enable syntax highlighting for ejs files
au BufNewFile,BufRead,BufEnter *.csv setf csv          " enable filetype for csv

" change cursor on insert mode if we can
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

fun! s:SetColorColumn()
	" highlight the last column of the textwidth
	if exists('+colorcolumn')
		" In Vim >= 7.3
		let &colorcolumn=&textwidth
	else
		" fallback for Vim < v7.3
		autocmd vimrc BufWinEnter * let w:m2=matchadd('ErrorMsg','\%>'.&textwidth.'v.\+', -1)
	endif
endfun

augroup colorcolumn
	autocmd!
	autocmd OptionSet textwidth call s:SetColorColumn()
	autocmd BufEnter * call s:SetColorColumn()
augroup end

set textwidth=120

hi clear SignColumn            " fix sign column background colors
hi Folded term=bold cterm=bold
set fillchars="fold: "         " remove the dashes from folds
set signcolumn=yes
" }}} END VIM APPEARANCE

" VIM BEHAVIOR {{{ =============================================================================================
"----------------------------------------------------------------------------------------------------------------------"
"                                                     VIM Behavior                                                     "
"----------------------------------------------------------------------------------------------------------------------"
filetype plugin indent on      " load filetype-specific plugin and indent files

set noshowmode                 " hide -- INSERT -- from command area since it is in the statusline
set wildmenu                   " visual autocomplete for command menu
set lazyredraw                 " redraw the screen only when we need to
set showmatch                  " highlight matching {}[]()
set incsearch                  " show search results as I type
set hlsearch                   " highlight all search results
set ignorecase                 " make search case insensitive
set smartcase                  " now if you use a capital letter search is case sensitive again
set noexpandtab                " prevent vi from expanding tabs to spaces
set copyindent                 " make vi maintain indentation level automatically
set cinoptions=(0,u0,U0        " make indenting of parameters look really nice
set preserveindent             " make vi use the same indent stucture as on the previous line
set shiftwidth=4               " use 4 spaces for each step of autoindent
set tabstop=4                  " make tabs count for 4 spaces
set breakindent                " make sure Vim will wrap indented lines correctly
set hidden                     " don't unload buffer when switching away
set backspace=indent,eol,start " sane backspace
set mouse=a                    " enable mouse for all modes settings
set mousemodel=popup           " right-click pops up context menu
set nomousehide                " don't hide the mouse cursor while typing
set ruler                      " show cursor position in status bar
set number                     " show absolute line number of the current line
set scrolloff=10               " scroll the window so we can always see 10 lines around the cursor
set cursorline                 " highlight the current line
set cursorcolumn               " highlight the current column
set printoptions=paper:letter  " user letter as the print output paper format
set shell=/bin/zsh             " define the shell to match my system shell
set foldenable                 " enable folding
set foldlevelstart=10          " open most folds by default
set foldmethod=syntax          " fold based on syntax settings
set modeline                   " turns on modelines (file specific settings)
set modelines=5                " tell vim to look at a comment on the last line of a file for file specific settings
set showcmd                    " show command in bottom bar

command! W :execute ':silent w !sudo tee % > /dev/null' | :edit! " save with sudo

autocmd nvimrc BufWritePre * :%s/\s\+$//e                " clear all trailing whitespace on save
autocmd filetype crontab setlocal nobackup nowritebackup " this lets vim edit the crontab on mac without error

" }}} END VIM BEHAVIOR

" VIM FUNCTIONS {{{ ============================================================================================
"------------------------------------------------------------------------------------------------------------------"
"                                                  VIM Functions                                                   "
"------------------------------------------------------------------------------------------------------------------"
" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
	let s:spccol = repeat(' ', a:cols)
	let s:result = substitute(a:indent, s:spccol, '\t', 'g')
	let s:result = substitute(s:result, ' \+\ze\t', '', 'g')
	if a:what == 1
		let s:result = substitute(s:result, '\t', s:spccol, 'g')
	endif
	return s:result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
	let s:savepos = getpos('.')
	let s:cols = empty(a:cols) ? &tabstop : a:cols
	execute a:line1 . ',' . a:line2 .  's/^\s\+/\=Indenting(submatch(0), a:what, s:cols)/e'
	call histdel('search', -1)
	call setpos('.', s:savepos)
endfunction

command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>''
" }}} END VIM FUNCTIONS

" this fixes devicons on resourcing vimrc
if exists("g:loaded_webdevicons")
	call webdevicons#refresh()
endif

" vim:foldmethod=marker:foldlevel=0:tabstop=4:shiftwidth=4:noexpandtab
