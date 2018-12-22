#!/bin/bash

SWD=$(pwd) # cash the staring working directory
cd "${BASH_SOURCE%/*}" || exit

# load in extra functions
. tools/functions
. tools/colors

cwd=$(pwd)

# ------------------------------------ Ask for the administrator password upfront ------------------------------------ #
format green "Start by getting permission------------------------------------------------------------------------------"
echo "Please provide your administrator password..."
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Create SSH key
if [[ ! -e "$HOME/.ssh/id_rsa" ]]; then
	format green "Creating an SSH key for you------------------------------------------------------------------------------"
	ssh-keygen -t rsa
fi

#==============================================================================#
#                              Tweak OS X Settings                             #
#==============================================================================#

cd "$cwd" || exit
case "$OSTYPE" in
	darwin* ) . tools/osx     ;;
	linux* )  . tools/linux   ;;
	* )       . tools/freebsd ;;
esac

format green "Setting up for development-------------------------------------------------------------------------------"
# GIT
cd "$cwd" && . tools/git || exit

# NODE
cd "$cwd" && . tools/node || exit



sudo -H pip  install setuptools
sudo -H pip  install --upgrade neovim
sudo -H pip2 install --upgrade neovim
sudo -H pip3 install --upgrade neovim

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

format green "Linking dot files----------------------------------------------------------------------------------------"
link_dotfiles

trap 'cd $SWD' EXIT

# vim:tabstop=4:shiftwidth=4
