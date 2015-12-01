#!/bin/bash

# load in extra functions
source tools/functions

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

#----------------------------- Check for Homebrew ------------------------------
if test ! "$(which brew)"; then
    # Install if we don't have it
    echo "Installing Hombrew-------------------------------------------------------"
    # Redirect stdin to /dev/null so that it won't ask if you are sure. This is
    # a hack and based on undocumented digging into the source so it may break
    # and need to be fixed
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
fi

#--------------------------- Update Homebrew recipes ---------------------------
echo "Updating Homebrew--------------------------------------------------------"
brew update

#--------- Install versioned formulae for the Homebrew package manager ---------
# These formulae provide multiple versions of existing packages, or newer
# versions of packages.
echo "Installing Hombrew Versions----------------------------------------------"
brew tap homebrew/versions

#---------------------- Install miscellaneous brew stuff -----------------------
echo "Installing other brew stuff----------------------------------------------"
brew install tree              # a visually easy to follow recursive ls
brew install wget              # adds wget (which should already be there)
brew install python            # This updates python
brew install shellcheck        # linter for shell scripts
brew install coreutils         # adds color to ls
brew install mobile-shell      # fault tollerent ssh
brew install terminal-notifier # send notifications from the termnal

#---------------------------- Setup for development ----------------------------
echo "Setting up for development-----------------------------------------------"


# GIT

echo "Installing Git..........................................................."
brew install git

echo "Git config..."
git config --global user.name "Jonathan Baird"
git config --global user.email "jtbairdj@gmail.com"

echo "Installing brew git utilities..."
brew install git-extras
brew install git-flow

# NODE

source tools/node

#==============================================================================#
#                            Get dotfiles form Github                          #
#==============================================================================#

echo "Getting dotfiles from Github..."
cd ~ || exit
git clone --recursive # add repo once I get it up there
cd ~/dotfiles || exit
link_dotfiles

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

# Apps
apps=(
    #-------------------------------- Browsers ---------------------------------
    firefox

    #---------------------------------- Media ----------------------------------
    vlc # because it can do all media
    handbrake # to encode all media


    #-------------------------- Workflow improvements --------------------------
    alfred # much better than spotlight (checkout the workflows)
    iterm2-beta # the latest release of iterm2 on the beta branch
    bettertouchtool

    #------------------------------- Development -------------------------------
    application-loader # for ios app development
    dockertoolbox # for managing docker
    gitx # my personal preference on gui git client
    java # make sure it is up to date
    macdown # intense markdown editor
    macvim # the gui vim for mac
    p4merge # this rocks merging in git
    slack
    sublime-text3
    virtualbox
    vagrant

    #------------------------------ General/Misc -------------------------------
    appcleaner # for tracking down app files when uninstalling
    disk-inventory-x # for managing full disks
    dropbox-experimental # get my data everywhere
    flux-beta # manage the color and brightness of your monitors to fight insomnia
    netgeargenie # for managing netgear routers
    nvalt # quick note taking
    yujitach-menumeters # activity monitor for the menubar

    #--------------------- upgrades for finders quicklook ----------------------
    qlcolorcode # syntax highlighting
    suspicious-package # see details of installation packages
    qlmarkdown # preview markdown files
    qlstephen # preview files without a file extension (i.e. INSTALL, MAKEFILE)
    #-------------------- would like it but it costs money ---------------------
    bartender # clean up the menubar
    harvest # timeclock app
    superduper # for backingup a backup
    # transmit # the #1 Mac OS X FTP client.
    # cleanmymac
    # glyphs
    #---------------------------------- MAYBE ----------------------------------
    # mailbox

)

#-------------------------------- Install apps ---------------------------------
echo "Installing apps with Cask------------------------------------------------"
brew cask install "${apps[0]}"

echo "Cleaning up..."
brew cask cleanup
brew cleanup

#==============================================================================#
#                                 Setup Sublime                                #
#==============================================================================#

setup_sublime

#==============================================================================#
#                              Tweak OS X Settings                             #
#==============================================================================#
source tools/osx

