function precmd {

	local TERMWIDTH
	(( TERMWIDTH = ${COLUMNS} - 1 ))


	###
	# Truncate the path if it's too long.

	PR_FILLBAR=""
	PR_PWDLEN=""

	local promptsize=${#${(%):-[%h]%n@%m:Smile!--------------- %t}}
	local pwdsize=${#${(%):-%~}}

	if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
		((PR_PWDLEN=$TERMWIDTH - $promptsize))
	else
	PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
	fi


}

function virtualenv_info {
	[ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function prompt_char {
	git branch >/dev/null 2>/dev/null && echo '±' && return
	hg root >/dev/null 2>/dev/null && echo 'Hg' && return
	echo '>'
}

##function battery_charge {
##	echo `~/bin/batcharge.py` 2>/dev/null
##}

setopt extended_glob

preexec () {
	if [[ "$TERM" == "screen" ]]; then
	local CMD=${1[(wr)^(*=*|sudo|-*)]}
	echo -n "\ek$CMD\e\\"
	fi
}


setprompt () {
	###
	# Need this so the prompt will work.

	setopt prompt_subst


	###
	# See if we can use colors.
	autoload colors zsh/terminfo
	if [[ "$terminfo[colors]" -ge 8 ]]; then
	colors
	fi
	for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	(( count = $count + 1 ))
	done
	PR_NO_COLOUR="%{$terminfo[sgr0]%}"


	###
	# See if we can use extended characters to look nicer.

	typeset -A altchar
	set -A altchar ${(s..)terminfo[acsc]}
	PR_SET_CHARSET="%{$terminfo[enacs]%}"
	PR_SHIFT_IN="%{$terminfo[smacs]%}"
	PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
	PR_HBAR=${altchar[q]:- }
	PR_ULCORNER=${altchar[l]:--}
	PR_LLCORNER=${altchar[m]:--}
	PR_LRCORNER=${altchar[j]:--}
	PR_URCORNER=${altchar[k]:--}

	ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
	ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
	ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}?"
	ZSH_THEME_GIT_PROMPT_CLEAN=""

	###
	# Decide if we need to set titlebar text.
	# case $TERM in
	# xterm*)
	# 	PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
	# 	;;
	# screen)
	# 	PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
	# 	;;
	# *)
	# 	PR_TITLEBAR=''
	# 	;;
	# esac


	###
	# Decide whether to set a screen title
	# if [[ "$TERM" == "screen" ]]; then
	# PR_STITLE=$'%{\ekzsh\e\\%}'
	# else
	# PR_STITLE=''
	# fi

	###
	# Finally, the prompt.

	PROMPT='%{$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}%}\
%{[35m%}%{$PR_PWDLEN%<...<%~%<<%}%{[32m%}[%h]%(!.%SROOT%s.%n)$PR_GREEN@%m:Smile!\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_HBAR${(e)PR_FILLBAR}$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
$(battery_level_gauge)%{[35m%}%t
$(emoji-clock) %{[0m%}$(prompt_char)'

	PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
}

RPROMPT='$(vi_mode_prompt_info)$(git_prompt_info)$(virtualenv_info)'

setprompt
