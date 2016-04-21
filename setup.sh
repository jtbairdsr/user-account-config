#!/bin/bash

# load in extra functions
source tools/functions
useraccountconfig=$(pwd)

#----------------- Ask for the administrator password upfront -----------------#
echo "Start by getting permission----------------------------------------------"
echo "Please provide your administrator password..."
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#------------------------------- Create SSH key -------------------------------#
echo "Creating an SSH key for you----------------------------------------------"
ssh-keygen -t rsa

#----------------------------- Get Xcode installed ----------------------------#
echo "Installing Xcode-stuff---------------------------------------------------"
xcode-select --install

#==============================================================================#
#                               Install Homebrew                               #
#                     The missing package manager for OS X                     #
#==============================================================================#

source tools/brew
#---------------------------- Setup for development ----------------------------
echo "Setting up for development-----------------------------------------------"


# GIT
cd $useraccountconfig
source tools/git

# NODE

cd $useraccountconfig
# source tools/node

# link_dotfiles

#==============================================================================#
#                             Install Custom Fonts                             #
#==============================================================================#

#------------------------------ Install Powerline ------------------------------
echo "Installing Powerline Fonts..."
mkdir ~/.custom-fonts
cd ~/.custom-fonts || exit
git clone https://github.com/powerline/fonts.git powerline
cd powerline || exit
install.sh

#---------------------- Clean-up after font installation -----------------------
cd ~ || exit
rm -rf .custom-fonts

#==============================================================================#
#                             Install Homebrew Cask                            #
#    Homebrew Cask extends Homebrew and brings its elegance, simplicity, and   #
#              speed to OS X applications and large binaries alike.            #
#==============================================================================#

#---------------------------- Install Hombrew Cask -----------------------------
echo "Installing Hombrew Cask--------------------------------------------------"
brew install caskroom/cask/brew-cask

source tools/cask-apps

#==============================================================================#
#                                 Setup Sublime                                #
#==============================================================================#

setup_sublime

#==============================================================================#
#                              Tweak OS X Settings                             #
#==============================================================================#
cd "$useraccountconfig"
source tools/osx

