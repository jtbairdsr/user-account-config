# @(#)local.profile 1.8	99/03/26 SMI

export ZDOTDIR=${1:-${ZDOTDIR:-$HOME}}
export SHELL=`type zsh | (read zsh is here; echo $here)`
export file ENV
export {MAN,CD,F,}PATH path
export WATCH=notme
export WATCHFMT="%n has %a %l from %m %@ %W"

stty istrip erase '^H' 2>/dev/null



export SAVEHIST=100000
HISTSIZE=$SAVEHIST export HISTSIZE
HISTFILE=$ZDOTDIR/.sh.history export HISTFILE
EDITOR=vim export EDITOR
PAGER=less export PAGER
ZSHEDIT=vim export ZSHEDIT

pathmunge ()
{
	local theVar=$1 ; shift
	local theValue
	eval theValue=\$$theVar
	while [ $# -gt 0 ]
	do
		if [ -d $1 -a -x $1 -a -r $1 -a $1 != after ] && ! echo $theValue | grep -E -q "(^|:)$1($|:)" ; then
			if [ "$2" = "after" ] ; then
				eval $theVar=$theValue:$1
			else
				eval $theVar=$1:$theValue
			fi
			eval theValue=\$$theVar
		fi
		shift
	done
}

[ -d $ZDOTDIR/bin/zsh ] || mkdir $ZDOTDIR/bin/zsh
pathmunge FPATH $ZDOTDIR/bin/zsh
pathmunge PATH $ZDOTDIR/bin /sbin after /usr/sbin after /usr/local/bin after /usr/local/sbin after /usr/X11R6/bin after
pathmunge CDPATH .. after ~ after /home after /usr/local/etc after /src/BuilderFusion after
# I want man to be in my path so that if I can read man pages in a man path relative to pwd
# so I have to seed MANPATH as follows (rather than just pathmunge the whole thing, since pathmunge
# won't add a non-existent path)
MANPATH=:man
pathmunge MANPATH /usr/man after /usr/local/man after /usr/share/man after

RPROMPT="[%T]"	 export RPROMPT

export BLOCKSIZE=M
export log=/var/log/bf
SHORTCUTS=(alt work db `ls $ZDOTDIR/.shortcuts 2>/dev/null`)

[ -f $ZDOTDIR/.zprofile.local ] && . $ZDOTDIR/.zprofile.local
