#!/bin/zsh
# assign present working directory to a variable so we can return here when we are done
PWD=`pwd`
BUNDLES="~/.vim/bundles"
mkdir ~/.vim
mkdir $BUNDLES

# the function that installs the pathogens {{{
	function pathogenInfect {
		DIRS=("${(@s|/|)2}")
		LENGTH=${#DIRS[@]}
		LAST_POSITION=("${(@s/./)${DIRS[${LENGTH}]}}")
		BUNDLE=${LAST_POSITION[1]}
		git clone $2 $BUNDLES/$BUNDLE
	}
# }}}
# install and compile the command-t plugin{{{
	pathogenInfect https://github.com/wincent/command-t.git
	cd ~/.vim/bundle/command-t
	git submodules init
	cd ruby/command-t
	ruby extconf.rb
	make
# }}}
# install Tern_For_Vim plugin and npm install tern{{{
	pathogenInfect https://github.com/marijnh/tern_for_vim.git
	cd $BUNDLES/tern_for_vim
	npm install
# }}}
# install and compile YouCompleteMe plugin{{{
#	brew update
#	brew upgrade
#	brew install python
#	brew install vim --with-perl --HEAD
#	brew install cmake
#	pip install fluke8
#	pip install nose
#	pathogenInfect https://github.com/Valloric/YouCompleteMe.git
#	cd $BUNDLES/YouCompleteMe
#	git submodule update --init --recursive
#	EXTRA_CMAKE_ARGS="-DEXTERNAL_LIBCLANG_PATH=`mdfind -name libclang.dylib`"
#	./install.sh --clang-completer --omnisharp-completer --system-libclang
# }}}
# install and compile VimProc plugin{{{
	pathogenInfect https://github.com/Shougo/vimproc.vim.git
	cd $BUNDLES/vimproc.vim
	make
# }}}
# install the plugins that don't need to be compiled{{{
	pathogenInfect https://github.com/rking/ag.vim.git
	pathogenInfect https://github.com/chrisbra/Colorizer.git
	pathogenInfect https://github.com/chrisbra/csv.vim.git
	pathogenInfect https://github.com/sjl/gundo.vim.git
	pathogenInfect https://github.com/Yggdroot/indentLine.git
	pathogenInfect https://github.com/othree/javascript-libraries-syntax.vim.git
	pathogenInfect https://github.com/scrooloose/nerdcommenter.git
	pathogenInfect https://github.com/scrooloose/nerdtree.git
	pathogenInfect https://github.com/jistr/vim-nerdtree-tabs.git
	pathogenInfect https://github.com/edkolev/promptline.vim.git
	pathogenInfect https://github.com/scrooloose/syntastic.git
	pathogenInfect https://github.com/godlygeek/tabular.git
	pathogenInfect https://github.com/marijnh/tern_for_vim.git
	pathogenInfect https://github.com/vim-scripts/text-object-left-and-right.git
	pathogenInfect https://github.com/tpope/vim-abolish.git
	pathogenInfect https://github.com/bling/vim-airline.git
	pathogenInfect https://github.com/neitanod/vim-clevertab.git
	pathogenInfect https://github.com/altercation/vim-colors-solarized.git
	pathogenInfect https://github.com/tpope/vim-commentary.git
	pathogenInfect https://github.com/Lokaltog/vim-easymotion.git
	pathogenInfect https://github.com/tpope/vim-fugitive.git
	pathogenInfect https://github.com/tpope/vim-git.git
	pathogenInfect https://github.com/airblade/vim-gitgutter.git
	pathogenInfect https://github.com/nathanaelkane/vim-indent-guides.git
	pathogenInfect https://github.com/michaeljsmith/vim-indent-object.git
	pathogenInfect https://github.com/pangloss/vim-javascript.git
	pathogenInfect https://github.com/jelera/vim-javascript-syntax.git
	pathogenInfect https://github.com/xolox/vim-misc.git
	pathogenInfect https://github.com/airblade/vim-rooter.git
	pathogenInfect https://github.com/tpope/vim-scriptease.git
	pathogenInfect https://github.com/tpope/vim-sensible.git
	pathogenInfect https://github.com/tpope/vim-speeddating.git
	pathogenInfect https://github.com/tpope/vim-surround.git
	pathogenInfect https://github.com/bronson/vim-trailing-whitespace.git
	pathogenInfect https://github.com/bronson/vim-visual-star-search.git
	pathogenInfect https://github.com/Shougo/vimshell.vim.git
# }}}
