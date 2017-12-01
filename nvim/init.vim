scriptencoding utf-8

augroup nvimrc
	autocmd!
augroup END

set shell=bash\ -i

" INITIALIZE PLUG {{{ ==========================================================================================
"----------------------------------------------------------------------------------------------------------------------"
"                                                    INITIALIZE PLUG                                                   "
"----------------------------------------------------------------------------------------------------------------------"
	if empty(glob('~/.vim/autoload/plug.vim'))
		silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
			\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		autocmd nvimrc VimEnter * PlugInstall --sync | source $MYVIMRC
	endif

	call plug#begin()

	" General {{{ -------------------------------------------------------------------------------------------------
	Plug 'airblade/vim-rooter'                                                " Changes Vim working directory to project root
	Plug 'alvan/vim-closetag'                                                 " Auto close (X)HTML tags
	Plug 'bdauria/angular-cli.vim'                                            " support for angular-cli, directly inside Vim
	Plug 'bronson/vim-visual-star-search'                                     " Start a * or # search from a visual block
	Plug 'cakebaker/scss-syntax.vim'                                          " syntax file for scss
	Plug 'chiel92/vim-autoformat'                                             " Format code with one button press
	Plug 'chr4/nginx.vim'                                                     " Improved nginx vim plugin (incl. syntax highlighting)
	Plug 'chrisbra/Colorizer'                                                 " color hex codes and color names
	Plug 'chrisbra/csv.vim'                                                   " A Filetype plugin for csv files
	Plug 'christoomey/vim-tmux-navigator'                                     " Seamless navigation between tmux panes and vim splits
	Plug 'ctrlpvim/ctrlp.vim'                                                 " Full path fuzzy file, buffer, mru, tag, ... finder
	Plug 'danhodos/vim-comb', { 'do': 'npm i -g csscomb' }                    " Tool for sorting CSS properties in specific order
	Plug 'easymotion/vim-easymotion'                                          " Vim motion on speed
	Plug 'editorconfig/editorconfig-vim'                                      " This is an EditorConfig plugin for Vim
	Plug 'ervandew/supertab'                                                  " allows you to use <Tab> for all your insert completion needs
	Plug 'farmergreg/vim-lastplace'                                           " Intelligently reopen files at your last edit position
	Plug 'godlygeek/tabular'                                                  " for text filtering and alignment
	Plug 'gregsexton/gitv', { 'on': [ 'Gitv' ] }                              " a 'gitk clone' plugin. Visualy isnpect a repo
	Plug 'heavenshell/vim-jsdoc'                                              " Generate JSDoc to your JavaScript code
	Plug 'honza/vim-snippets'                                                 " contains snippets files for various programming languages
	Plug 'jiangmiao/auto-pairs'                                               " insert or delete brackets, parens, quotes in pairs
	Plug 'jtbairdsr/vim-center-comment'                                       " for formatting comments to center
	Plug 'kshenoy/vim-signature'                                              " Plugin to toggle, display and navigate marks
	Plug 'leafgarland/typescript-vim'                                         " Typescript syntax files for Vim
	Plug 'leshill/vim-json'                                                   " Syntax highlighting for JSON
	Plug 'mhinz/vim-signify'                                                  " shows a VCS diff in the sign column
	Plug 'mhinz/vim-startify'                                                 " provides a start screen for Vim and Neovim.
	Plug 'michaeljsmith/vim-indent-object'                                    " defines text object for lines of code at the same indent level
	Plug 'mileszs/ack.vim'                                                    " run ack (or ag) from Vim
	Plug 'nikvdp/ejs-syntax'                                                  " syntax file for editing ejs files in vim
	Plug 'ntpeters/vim-better-whitespace'                                     " Better whitespace highlighting
	Plug 'othree/javascript-libraries-syntax.vim'                             " Syntax files for JavaScript libraries (underscore angular etc.)
	Plug 'pangloss/vim-javascript'                                            " provides syntax highlighting and improved indentation
	Plug 'plasticboy/vim-markdown'                                            " Syntax highlighting, matching rules and mappings for Markdown
	Plug 'quramy/tsuquyomi', { 'do': 'npm i -g typescript' }                  " make your Vim a TypeScript IDE
	Plug 'quramy/vim-js-pretty-template'                                      " highlights JavaScript's Template Strings in other FileType syntax rule
	Plug 'scrooloose/nerdcommenter'                                           " intensely orgasmic commenting
	Plug 'severin-lemaignan/vim-minimap'                                      " A Sublime-like minimap for VIM
	Plug 'shougo/vimproc.vim', { 'do': 'make' }                               " required by tsuquyomi
	Plug 'sirver/ultisnips'                                                   " the ultimate snippet solution for Vim
	Plug 'sjl/gundo.vim'                                                      " visualize your Vim undo tree
	Plug 'suan/vim-instant-markdown', { 'do': 'npm i -g instant-markdown-d' } " Instant Markdown previews
	Plug 'svermeulen/vim-easyclip'                                            " Simplified clipboard functionality for Vim
	Plug 'terryma/vim-multiple-cursors'                                       " attempt at Sublime Text's multiple selection feature
	Plug 'tmux-plugins/vim-tmux'                                              " proper syntax highlighting etc.
	Plug 'tmux-plugins/vim-tmux-focus-events'                                 " restores FocusGained/FocusLost autocommand events when inside Tmux.
	Plug 'tpope/vim-abolish'                                                  " find, substitute, and abbreviate multiple variants of a word
	Plug 'tpope/vim-dispatch'                                                 " asynchronous build and test dispatcher
	Plug 'tpope/vim-fugitive'                                                 " git of the gods plugin
	Plug 'tpope/vim-obsession'                                                " continuously updated session files
	Plug 'tpope/vim-repeat'                                                   " enable repeating supported plugin maps with '.'
	Plug 'tpope/vim-sleuth'                                                   " automatically adjusts 'shiftwidth' and 'expandtab'
	Plug 'tpope/vim-speeddating'                                              " use CTRL-A/CTRL-X to increment dates, times, and more
	Plug 'tpope/vim-surround'                                                 " provides mappings to delete, change and add surrounding pairs
	Plug 'tpope/vim-unimpaired'                                               " pairs of handy bracket mappings
	Plug 'triglav/vim-visual-increment'                                       " increasing sequence of numbers or letters via visual mode
	Plug 'valloric/MatchTagAlways'                                            " always highlights the enclosing html/xml tags
	Plug 'vim-airline/vim-airline'                                            " Lean & mean status/tabline for vim that's light as air.
	Plug 'vim-airline/vim-airline-themes'                                     " A collection of themes for vim-airline
	Plug 'vim-scripts/bufexplorer.zip'                                        " quickly and easily switch between buffers
	Plug 'vim-scripts/searchcomplete'                                         " tab-complete words while typing in a search
	Plug 'vim-scripts/text-object-left-and-right'                             " create text object for left and right of a statement
	Plug 'w0rp/ale'                                                           " Asynchronous Lint Engine
	Plug 'wellle/targets.vim'                                                 " provides additional text objects
	Plug 'wellle/tmux-complete.vim'                                           " insert mode completion of words in adjacent tmux panes
	Plug 'wellle/visual-split.vim'                                            " control splits with visual selections or text objects
	Plug 'wgwoods/vim-systemd-syntax'                                         " Syntax highlighting for systemd service files
	Plug 'yggdroot/indentLine'                                                " display the indention levels with thin vertical lines
	Plug 'zenbro/mirror.vim'                                                  " edit remote files on multiple environments
	Plug 'zhaocai/GoldenView.Vim'                                             " Always have a nice view for vim split windows
	" }}} End General

	" YCM {{{
	Plug 'tenfyzhong/CompleteParameter.vim'
	Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }                       " enables tern completions
	Plug 'valloric/YouCompleteMe',  { 'do': './install.py --js-completer' }   " the ultimate vim completion engine
	" }}}

	" Deoplete {{{ ------------------------------------------------------------------------------------------------
	Plug 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " asynchronous keyword completion system
	Plug 'shougo/deoplete-zsh'                                    " Zsh completion for deoplete.nvim
	Plug 'shougo/neco-vim'                                        " vim completions for deoplete
	Plug 'shougo/neoinclude.vim'                                  " include completion framework for deoplete
	" }}} End Deoplete

	" NERDTree {{{ ------------------------------------------------------------------------------------------------
	Plug 'scrooloose/nerdtree'                     " allows you to explore your filesystem and open files/directories.
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " this adds syntax for nerdtree on most common file extensions.
	Plug 'scrooloose/nerdtree-project-plugin'      " proof of concept for nerdtree projects
	Plug 'xuyuanp/nerdtree-git-plugin'             " makes NERDTree show git status flags
	Plug 'octref/RootIgnore'                       " Set wildignore from git repo root
	" }}} End NERDTree

	" Unused plugins that I might want later. {{{ -----------------------------------------------------------------
	" Plug 'akz92/vim-ionic2'                 " Ionic 2 syntax highlighting
	" Plug 'burnettk/vim-angular'             " Some niceties for using Vim with the AngularJS(1.*) framework
	" Plug 'janko-m/vim-test'                 " a vim wrapper for running tests on different granularities
	" Plug 'maksimr/vim-karma'                " lightweight Karma runner
	" Plug 'matthewsimo/angular-vim-snippets' " snippets for AngularJS(1.*): JavaScript, HTML, CoffeeScript, HAML.
	" Plug 'vim-scripts/a.vim'                " swtich between source files and header files quickly
	" Plug 'vim-scripts/closetag.vim'         " eases redundant typing when writing html or xml files
	" }}} End Unused

	" Color schemes {{{ -------------------------------------------------------------------------------------------
	Plug 'flazz/vim-colorschemes' " any colorscheme I could want...
	" }}} End Color schemes

	" !!!MUST BE LOADED LAST!!! {{{ -------------------------------------------------------------------------------
	Plug 'ryanoasis/vim-devicons' " Adds file type glyphs/icons to NERDTree, vim-airline, and others
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

	" ---------- Airline --------- {{{ - bundle names: vim-airline/vim-airline, vim-airline-themes -----------------
		let g:airline#extensions#tmuxline#enabled     = 0
		let g:airline_powerline_fonts                 = 1
		let g:airline_theme                           = 'solarized'
		let g:airline_solarized_bg                    = 'light'
		let g:airline#extensions#tabline#enabled      = 1
		let g:airline#extensions#tabline#left_sep     = ' '
		let g:airline#extensions#tabline#left_alt_sep = '|'
	" }}} End Airline

	" ------------ ALE ----------- {{{ - bundle name: w0rp/ale -----------------------------------------------------
		let g:ale_fix_on_save                = 1   " fix files automatically on save.
		let g:ale_completion_enabled         = 1   " Enable completion where available.
		let g:ale_sign_column_always         = 1   " keep the sign gutter open always
		let g:ale_set_quickfix               = 1   " use the quckrix window
		let g:ale_sign_error                 = '' " change the error sign
		let g:ale_sign_error                 = '' " change the error sign
		let g:ale_sign_warning               = '' " change the warning sign
		let g:airline#extensions#ale#enabled = 1   " add to status line...
		" let g:ale_open_list                  = 1   " open quickfix window when there are errors

		" After this is configured, :ALEFix will try and fix your JS code with ESLint.
		let g:ale_fixers = {
			\ 'javascript': ['prettier'],
			\ 'typescript': ['prettier'],
			\ 'scss': ['prettier'],
			\ 'css': ['prettier'],
		\ }

		let g:ale_linters = {
			\ 'html': ['HTMLHint', 'proselint'],
			\ 'dockerfile': ['hadolint'],
			\ 'javascript': ['eslint', 'flow', 'prettier'],
			\ 'typescript': ['tslint', 'tsc'],
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
		\ }
	" }}} End ALE

	" -------- Angular CLI ------- {{{ - bundle name: bdauria/angular-cli.vim --------------------------------------
		" initialize in all html and typescript files
		autocmd nvimrc FileType typescript,html call angular_cli#init()

		" enable usage of asynchronous dispatch
		let g:angular_cli_use_dispatch = 1
	" }}}

	" -------- Autoformat -------- {{{ - bundle name: chiel92/vim-autoformat ---------------------------------------
		" map format to <F3>
		noremap <F3> :Autoformat<CR>
		" format file on save
		au nvimrc BufWrite * :Autoformat
	" }}} End Autoformat

	" --------- CloseTag --------- {{{ - bundle name: alvan/closetag ( Not Installed ) -----------------------------
		" Add > at current position without closing the current tag, default is ''
		" let g:closetag_close_shortcut = '<leader>>'
		" let g:closetag_filenames = '*.svg,*.xml,*.html,*.xhtml,*.phtml'
		" let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.html'
		" au BufRead,BufNewFile,BufEnter *.html set syntax=html
	" }}}

	" --------- Colorizer -------- {{{ - bundle name: chrisbra/Colorizer -------------------------------------------
	" }}}

	" ------- Color Schemes ------ {{{ - bundle name: flazz/vim-colorschemes ---------------------------------------
		set background=light  " default to a nice light background
		colorscheme solarized " a nice color scheme

		" create a mapping that lets me change from light to dark on the fly
		map <F1> :set background=light<CR>

		" create a mapping that lets me change from light to dark on the fly
		map <F2> :set background=dark<CR>
	" }}} End Color Schemes

	" ---------- CSScomb --------- {{{ - bundle name: danhodos/vim-comb --------------------------------------------
		" Automatically comb your CSS on save
		autocmd nvimrc BufWritePre,FileWritePre *.css,*.less,*.scss,*.sass silent! :call CSScomb()
		autocmd nvimrc FileType scss,css nnoremap <buffer> <F6> :call CSScomb()<CR>

		function! CSScomb()
			execute 'silent !csscomb '.expand('%')
			redraw!
		endfunction
	" }}}

	" ---------- CtrlP ----------- {{{ - bundle name: ctrlpvim/ctrlp.vim -------------------------------------------
		nnoremap <C-p> :CtrlP<CR>

		set wildignore+=*/tmp/*,*.so,*.swp,*.zip " MacOSX/Linux
		set wildignore+=*\\tmp\\*,*.exe          " Windows

		let g:ctrlp_working_path_mode = 'ra'
		let g:ctrlp_root_markers = ['package.json']
		if executable('ag')
			let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""' " use ag 'the silver searcher' because it is blisteringly fast
		else
			let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard'] " ignore everything that .gitignore ignores
		endif
	" }}}

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
		let g:EasyClipAutoFormat             = 1
		let g:EasyClipShareYanks             = 1
		let g:EasyClipShowYanksWidth         = 120
		let g:EasyClipUseSubstituteDefaults  = 1
		let g:EasyClipUsePasteToggleDefaults = 0

		set clipboard=unnamed

		nmap <C-f> <Plug>EasyClipSwapPasteForward
		nmap <C-d> <Plug>EasyClipSwapPasteBackwards
		imap <C-v> <Plug>EasyClipInsertModePaste
		cmap <C-v> <Plug>EasyClipCommandModePaste
		nmap <Leader>cf <Plug>EasyClipToggleFormattedPaste
		nnoremap gm m
	" }}}

	" -------- EasyMotion -------- {{{ - bundle name: easymotion/vim-easymotion ------------------------------------
		map <Space> <Plug>(easymotion-prefix)
	" }}}End EasyMotion

	" --------- Fugitive --------- {{{ - bundle name: tpope/vim-fugitive -------------------------------------------
		noremap <Leader>gs :Gstatus<CR>
		noremap <Leader>gc :Gcommit<CR>
		noremap <Leader>gw :Gwrite<CR>
		noremap <Leader>gr :Gread<CR>
		noremap <Leader>gl :Glog<CR>
		noremap <Leader>gd :Gdiff<CR>
	" }}} End Fugitive

	" -------- GoldenView -------- {{{ - bundle name: zhaocai/GoldenView.Vim ---------------------------------------
		let g:goldenview__enable_default_mapping = 0
		let g:goldenview__enable_at_startup      = 1
	" }}}

	" ---------- Gundo ----------- {{{ - bundle name: sjl/gundo.vim ------------------------------------------------
		nnoremap <F5> :GundoToggle<CR>
	" }}} End Gundo

	" -------- IndentLine -------- {{{ - bundle name: Yggdroot/indentLine ------------------------------------------
		let g:indentLine_setColors            = 0
		" let g:indentLine_leadingSpaceEnabled  = 1   "  mark leading spaces
		let g:indentLine_leadingSpaceChar     = '.' "  char to mark leading spaces
		let g:indentLine_showFirstIndentLevel = 0
		set list lcs=tab:\│\                        "  show tabs
	" }}} End IndentLine

	" -------- JavaScript -------- {{{ - bundle name: pangloss/vim-javascript --------------------------------------
		let g:javascript_plugin_jsdoc = 1
		let g:javascript_plugin_ngdoc = 1
		let g:javascript_plugin_flow  = 1
	" }}} End Vim Javascript

	" Javascript Libraries Syntax  {{{ - bundle name: othree/javascript-libraries-syntax.vim -----------------------
		let g:used_javascript_libs = 'underscore,angularjs,jquery'
	" }}}

	" ----------- JSDoc ---------- {{{ - bundle name: heavenshell/vim-jsdoc-----------------------------------------
		let g:jsdoc_allow_input_prompt = 1 " Allow prompt for interactive input
		let g:jsdoc_input_description = 1 " Prompt for a function description
		let g:jsdoc_enable_es6 = 1 " Enable ES6 shorthand function, arrow functions

		" puts jsdoc above last function
		nmap <silent> <C-1> ?function<cr>:noh<cr><Plug>(jsdoc)
	" }}} End JSDoc

	" ----- JSPrettyTemplate ----- {{{ - bundle name: Quramy/vim-js-pretty-template --------------------------------
		" Register tag name associated the filetype
		call jspretmpl#register_tag('md', 'markdown')
		call jspretmpl#register_tag('sql', 'sql')

		autocmd nvimrc FileType javascript JsPreTmpl html
		autocmd nvimrc FileType typesciprt JsPreTmpl html
	" }}}

	" --------- MiniMap ---------- {{{ - bundle name: severin-lemaignan/vim-minimap --------------------------------
		let g:mimimap_highlight = 'Visual'
	" }}}

	" ------ NERD-Commenter ------ {{{ - bundle name: scrooloose/nerdcommenter -------------------------------------
		" map <F4> to start a new comment while in insert mode
		imap <F4> <Plug>NERDCommenterInsert

		let g:NERDSpaceDelims            = 1      " Add spaces after comment delimeters by default
		let g:NERDCompactSexyComs        = 1      " Use compact syntax for prettified multi-line comments
		let g:NERDDefaultAlign           = 'left' " Align line comments left, don't follow code indentation
		let g:NERDCommentEmptyLines      = 1      " Allow commenting empty lines (good for commenting a region)
		let g:NERDTrimTrailingWhitespace = 1      " Enable trimming of trailing whitespace when uncommenting
	" }}}

	" --------- NERD-Tree -------- {{{ - bundle name: scrooloose/nerdtree ------------------------------------------
		noremap \nf  :NERDTreeFind<CR>
		noremap <F5> :NERDTreeToggle<CR>

		let g:NERDTreeWinPos            = 'left' " place nerdtree on the left
		let g:NERDTreeQuitOnOpen        = 1      " close the tree when we open a file
		let g:NERDTreeAutoDeleteBuffer  = 1      " delete the buffer when NERDTree is used to delete a file...
		let g:NERDTreeMinimalUI         = 1      " make it prettier
		let g:NERDTreeDirArrows         = 1      " make it prettier
		let g:NERDTreeHijackNetrw       = 1      " use nerdtree instead of netrw
		let g:NERDTreeRespectWildIgnore = 1      " don't show files/directories in .gitignore

		" close the tab if NERDTree is the only window left open
		autocmd nvimrc bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

		" start nerdtree if we open a directory
		" autocmd nvimrc StdinReadPre * let s:std_in=1
		" autocmd nvimrc VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
	" }}}End NERD-Tree and NERD-Tree_Tabs"

	" ------ NERD-Tree Git ------- {{{ - bundle name: xuyuanp/nerdtree-git-plugin ----------------------------------
		let g:NERDTreeIgnoredStatus = 1
	" }}} End NERD-Tree Git

	" NERDTree Syntax Highlighting {{{ - bundle name: tiagofumo/vim-nerdtree-syntax-highlight ----------------------
		" Highlight folders using exact match
		let g:NERDTreeHighlightFolders         = 1 " enables folder icon highlighting using exact match
		let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
	" }}}End NERDTree Syntax Highlighting

	" -------- SCSS-Syntax ------- {{{ - bundle name: cakebaker/scss-syntax.vim ------------------------------------
		au BufRead,BufNewFile,BufEnter *.scss set filetype=scss.css
		au BufRead,BufNewFile,BufEnter *.scss set syntax=scss
	" }}}

	" --------- ShowMarks -------- {{{ - bundle name: vim-scripts/ShowMarks ----------------------------------------
		" nmap <Leader>gmt
		" nmap <Leader>gmh
		" nmap <Leader>gma
		" nmap <Leader>gmm
	" }}}

	" --------- Supertab --------- {{{ - bundle name: ervandew/supertab --------------------------------------------
	" }}}End Supertab

	" --------- Tabular ---------- {{{ - bundle name: godlygeek/tabular --------------------------------------------
		map ,a= :Tabularize /=<CR>
		map ,a" :Tabularize /"<CR>
		map ,a: :Tabularize /:\zs<CR>
		map ,a/ :Tabularize ///\s<CR>
		map ,a# :Tabularize /#\s<CR>
		map ,af :Tabularize /from<CR>

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

	" --------- Tsuquyomi -------- {{{ - bundle name: quramy/tsuquyomi ---------------------------------------------
		let g:tsuquyomi_disable_quickfix = 1
		let g:syntastic_typescript_checkers = ['tsuquyomi', 'tslint'] " You shouldn't use 'tsc' checker.
	" }}} End Tsuquyomi

	" --------- UltiSnips -------- {{{ - bundle name: SirVer/ultisnips ---------------------------------------------
		let g:UltiSnipsExpandTrigger = '<c-e>'
	" }}} End UltiSnips

	" ---- Visual Star Search ---- {{{ - bundle name: bronson/vim-visual-star-search -------------------------------
		" use ag for recursive searching so we don't find 10,000 useless hits inside node_modules
		nnoremap <leader>* :call ag#Ag('grep', '--literal ' . shellescape(expand("<cword>")))<CR>
		vnoremap <leader>* :<C-u>call VisualStarSearchSet('/', 'raw')<CR>:call ag#Ag('grep', '--literal ' . shellescape(@/))<CR>
	" }}} End Visual Star Search

	" ------------ YCM ----------- {{{ - bundle name: Valloric/YouCompleteMe ---------------------------------------
		if !exists('g:ycm_semantic_triggers')
			let g:ycm_semantic_triggers = {}
		endif
		let g:ycm_semantic_triggers['typescript'] = ['.']
	" }}} End YCM

" }}} END PLUGIN SETTINGS

" KEY REMAPPING {{{ ============================================================================================
"----------------------------------------------------------------------------------------------------------------------"
"                                                     Key Remapping                                                    "
"----------------------------------------------------------------------------------------------------------------------"
	nnoremap <Leader>ev :vsp $MYVIMRC<CR>    " edit vimrc
	nnoremap <Leader>ez :vsp ~/.zshrc<CR>    " edit zshrc
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
			" In Vim >= 7.3, also highlight columns 160+
			let &colorcolumn=&textwidth.','.join(range(160,500),',')
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
" }}} END VIM APPEARANCE

" VIM BEHAVIOR {{{ =============================================================================================
"----------------------------------------------------------------------------------------------------------------------"
"                                                     VIM Behavior                                                     "
"----------------------------------------------------------------------------------------------------------------------"
	filetype plugin indent on      " load filetype-specific plugin and indent files

	set wildmenu                   " visual autocomplete for command menu
	set lazyredraw                 " redraw the screen only when we need to
	set showmatch                  " highlight matching {}[]()
	set incsearch                  " show search results as I type
	set hlsearch                   " highlight all search results
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

	autocmd nvimrc BufWritePre * :%s/\s\+$//e                        " clear all trailing whitespace on save

	" Change color scheme to dark at night but light during the day
	let s:hour = strftime('%H')
	if s:hour >= 6 && s:hour < 18
		set background=light
	else
		set background=dark
	endif
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

" vim:foldmethod=marker:foldlevel=0:tabstop=4:shiftwidth=4
