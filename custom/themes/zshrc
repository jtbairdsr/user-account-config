#!/bin/zsh

set -J
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

bindkey -v
autoload -U compinit; compinit
alias systemctl='sudo systemctl'
alias Ping=`set -- \`type ping\`; echo $3`
alias ping="ping -c2"
alias scp='scp -C'
alias rsync='rsync --partial --compress --archive'
alias grep='grep --color'
alias fgrep='grep -F'
alias gerrit='ssh gerrit.admin gerrit'
alias mongo='rlwrap -a dummy mongo'


alias ls='ls -F'
alias h=history

alias showpid='ps ${SHOWPIDFLAGS:--auxl} | head -1 >&2; ps ${SHOWPIDFLAGS:--auxl} | grep -v grep | grep -i'
alias sp=showpid

alias showenv='env | grep -i'
alias ftp='ftp -i'
if type cvs > /dev/null 2> /dev/null
then
	alias status='cvs status 2>&1 | fgrep -v .swp | fgrep -v .DS_Store | grep -E "^((\?.*)|(.*Status: [^U]))"'
	alias Status='cvs status 2>/dev/null | grep -A3 Locally.Modified | grep Repository | cut -d/ -f7- | cut -d, -f1'
	alias csv=cvs
fi

for x in zoe bfit{,2} backup oasis jenkins riff torg blacktop ricks provo orem afton ormoc tarlac luzon davao
	alias $x="ssh $x"
alias bfdba='ssh -tt zoe ssh -tt bfdba'

alias vi=vim

# this command makes most file operations faster: rm/ln/mv/chmod/chgrp/mkdir/rmdir
zmodload zsh/files
zmodload zsh/stat
alias size='stat +size'

for x in `(for x in $SHORTCUTS; echo $x ; ls $ZDOTDIR/.shortcuts 2>/dev/null) | sort -u `
do
	[ -d $ZDOTDIR/.shortcuts ] || mkdir $ZDOTDIR/.shortcuts
	[ -f $ZDOTDIR/.$x ] && mv $ZDOTDIR/.$x $ZDOTDIR/.shortcuts/$x
	[ -f $ZDOTDIR/.shortcuts/$x ] || echo $HOME > $ZDOTDIR/.shortcuts/$x
	export $x="`cat $ZDOTDIR/.shortcuts/$x`"
	alias set$x="$x=\`pwd\`;echo \$$x > $ZDOTDIR/.shortcuts/$x"
	alias $x="cd \"\$$x\"; pwd"
	hash -d "$x"
done

# ps flags for redhat Darwin
if [ `uname` = Linux ]
then
	# cuz it can't export an array, and yet it wants this to be 
	# an array so that the args to the "o" switch  are in the
	# next positional parameter
	SHOWPIDFLAGS=(axwwwwo user,pid,ppid,%cpu,%mem,lstart,tty,state,command)
fi

alias df='df -h'

alias mkPatch='diff -Naur'

# make sure that we unfunction any system functions we override
unfunction -U $ZDOTDIR/bin/zsh/*(:t) 2>/dev/null > /dev/null
autoload -U $ZDOTDIR/bin/zsh/*(:t)

zle -N sudo-command-line
bindkey -a "\e\e" sudo-command-line
[ -f $ZDOTDIR/.zshrc.local ] && . $ZDOTDIR/.zshrc.local

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
