#!/bin/bash
#-------------------------------------------------- Set Basic Colors ---------------------------------------------------
autoload colors zsh/terminfo
# autoload colors && colors

# shellcheck source=colors
RESET_COLOR="%{$reset_color%}"

#..................................................... foreground ......................................................
RED_FG="%{$fg[red]%}"
GREEN_FG="%{$fg[green]%}"
YELLOW_FG="%{$fg[yellow]%}"
BLUE_FG="%{$fg[blue]%}"
MAGENTA_FG="%{$fg[magenta]%}"
CYAN_FG="%{$fg[cyan]%}"
WHITE_FG="%{$fg[white]%}"
BLACK_FG="%{$fg[black]%}"
#..................................................... background ......................................................
RED_BG="%{$bg[red]%}"
GREEN_BG="%{$bg[green]%}"
YELLOW_BG="%{$bg[yellow]%}"
BLUE_BG="%{$bg[blue]%}"
MAGENTA_BG="%{$bg[magenta]%}"
CYAN_BG="%{$bg[cyan]%}"
WHITE_BG="%{$bg[white]%}"
BLACK_BG="%{$bg[black]%}"

#........................................................ blink ........................................................
BLACK_BL="%{\033[5;30m%}"
RED_BL="%{\033[5;31m%}"

#======================================================================================================================#
#                                               Cool Character Variables                                               #
#======================================================================================================================#
typeset -A altchar
set -A altchar ${(s..)terminfo[acsc]}

PR_SET_CHARSET="%{$terminfo[enacs]%}"
PR_SHIFT_IN="%{$terminfo[smacs]%}"
PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
PR_HBAR=${altchar[q]:--}
PR_VBAR=${altchar[x]:--}
PR_ULCORNER=${altchar[l]:--}
PR_LLCORNER=${altchar[m]:--}
PR_LRCORNER=${altchar[j]:--}
PR_URCORNER=${altchar[k]:--}

SOLID_SEPARATOR_RIGHT="\ue0b2"    # 
LINE_SEPARATOR_RIGHT="\ue0b3"     # 
SOLID_SEPARATOR_LEFT="\ue0b0"     # 
LINE_SEPARATOR_LEFT="\ue0b1"      # 

PLUG_CHAR=" \uf1e6  "             # 
BATTERY_0=" \uf244  "             # 
BATTERY_25=" \uf243  "            # 
BATTERY_50=" \uf242  "            # 
BATTERY_75=" \uf241  "            # 
BATTERY_100=" \uf240  "           # 
BATTERY_CHARGING=" \u26a1\u26a1 " # ⚡

GIT_CHAR=" \uf1d3 "               # 
DETACHED_CHAR=" \uf417 "          # 
BRANCH_CHAR=" \uf418 "            # 
MERGE_CHAR=" \uf419 "             # 
REBASE_CHAR=" \uf47f "            # 
BISECT_LOG_CHAR=" \uf46f "        # 
UNTRACKED_CHAR=" \u2026 "         # …
CHANGED_CHAR=" \u271a "           # ✚
CONFLICTS_CHAR=" \uf00d "         # 
STAGED_CHAR=" \u25cf "            # ●
CLEAN_CHAR=" \uf00c "             # 

NODE_SYMBOL=" \ue718"             # 
SUPERMAN=" \uf43b"                # 
CROSS_CHAR=" \uf00d"              # 
DIRTY_CHAR=" \u00b1 "             # ±
GEAR_CHAR=" \uf013 "              # 
ARROW_UP_CHAR="\uf062 "           # 
ARROW_DOWN_CHAR="\uf063 "         # 
RIGHT_SHIFT=" \uf101 "            # 
LEFT_SHIFT=" \uf100 "             # 
PROMPT_CHAR="\uf054"              # 

CURRENT_BG="NONE"
CURRENT_FG="NONE"

#======================================================================================================================#
#                                                       Segments                                                       #
#======================================================================================================================#

SEGMENT_START=$PR_SHIFT_IN$PR_ULCORNER$PR_HBAR$PR_SHIFT_OUT
SEGMENT_END="$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PROMPT_CHAR %{%k%f%}"

LENGTH_START=2
LENGTH_BATTERY=4
LENGTH_PATH=0



function check_lengths {
	echo TIME: $LENGTH_TIME
	echo BATTERY: $LENGTH_BATTERY
	echo NVM: $LENGTH_NVM
	echo CONTEXT: $LENGTH_CONTEXT
	echo PATH: $LENGTH_PATH
	echo MESSAGE: $LENGTH_MESSAGE
	echo DIVIDER: $LENGTH_DIVIDER
	echo HISTORY: $LENGTH_HISTORY
	echo STATUS: $LENGTH_STATUS
}

function check_font {
	echo "SEPARATORS"
	echo $SOLID_SEPARATOR_RIGHT$SOLID_SEPARATOR_LEFT$LINE_SEPARATOR_RIGHT$LINE_SEPARATOR_LEFT
	echo
	echo "GIT"
	echo $GIT_CHAR$MERGE_CHAR$REBASE_CHAR$BISECT_LOG_CHAR$BRANCH_CHAR$DETACHED_CHAR$UNTRACKED_CHAR$CHANGED_CHAR$CONFLICTS_CHAR$STAGED_CHAR$CLEAN_CHAR
	echo
	echo "POWER"
	echo $PLUG_CHAR$BATTERY_0$BATTERY_25$BATTERY_50$BATTERY_75$BATTERY_CHARGING$BATTERY_100
	echo
	echo "MISC"
	echo $SUPERMAN$CROSS_CHAR$RIGHT_SHIFT$LEFT_SHIFT$DIRTY_CHAR$GEAR_CHAR$ARROW_UP_CHAR$ARROW_DOWN_CHAR$PROMPT_CHAR
}

function clear_errors {
	return 0
}


#======================================================================================================================#
#                                                 L E F T   P R O M P T                                                #
#======================================================================================================================#
#======================================================================================================================#
#                                                       Utilities                                                      #
#======================================================================================================================#

function create_segments {
	# -------------------------------------------------------- NVM -----------------------------------------------------
	nvm_content > temp
	SEGMENT_NVM=`cat temp`

	# ------------------------------------------------------- TIME -----------------------------------------------------
	time_content > temp
	SEGMENT_TIME=`cat temp`
	
	# ------------------------------------------------------ BATTERY ---------------------------------------------------
	SEGMENT_BATTERY=$(battery_content)

	# ------------------------------------------------------ MESSAGE ---------------------------------------------------
	message_content > temp
	SEGMENT_MESSAGE=`cat temp`

	# ------------------------------------------------------ CONTEXT ---------------------------------------------------
	SEGMENT_CONTEXT=$(context_content)
	LENGTH_CONTEXT=${#${SEGMENT_CONTEXT:-}}

	# ------------------------------------------------------- PATH -----------------------------------------------------
	path_content > temp
	SEGMENT_PATH=`cat temp`
	rm temp

	# ------------------------------------------------------ DIVIDER ---------------------------------------------------
	SEGMENT_DIVIDER=$(divider_content)

	# ------------------------------------------------------ HISOTRY ---------------------------------------------------
	SEGMENT_HISTORY=$(history_content)

	# ------------------------------------------------------ STATUS ----------------------------------------------------
	SEGMENT_STATUS=$(status_content)
}

function prompt_segment {
	local segment bg fg

	segment=${1:- }
	bg=${2:-$CURRENT_BG}
	fg=${3:-$CURRENT_FG}

	if [[ $bg == "$CURRENT_BG" ]]; then
		echo -n $segment
	else
		echo -n "%{%F{$fg}%K{$bg}%}$segment"
	fi

	CURRENT_BG=$bg
	CURRENT_FG=$fg
}

function get_lengths {
	# Determine How long the path can be and how long the divider will be
	#------------------------------------------------------------------------------------------------------------------#
	local user
	(( termwidth = $COLUMNS - 2 ))
	#------------------------------------------------------------------------------------------------------------------#
	#...................................................Explanation!...................................................#
	# ${[varname]:-[string]} - Returns the value of [varname] normally, but uses [string] instead if ${[varname]}      #
	#                            doesn't exist. ${:-[string]} is a quick way to do variable related things to fixed    #
	#                            strings.                                                                              #
	# ${([flags])[varname]}  - Uses the flags to alter how the value of the variable is handled. The percent sign      #
	#                            causes prompt expansion to be done on the variable. So ${(%):-%~} does prompt         #
	#                            expansion on the literal string "%~".                                                 #
	# ${#[varname]}          - Gives the length of the value of the variable. It appears that zsh handles the pound    #
	#                            sign before applying the (%) flag, so I had to nest the (%) flag in order to get      #
	#                            things to happen in the right order.                                                  #
	#------------------------------------------------------------------------------------------------------------------#
	pwd_len=${#${(%):-%~}}
}

function get_prompt_len {
	echo -n $(( $LENGTH_START + $LENGTH_TIME + $LENGTH_BATTERY + $LENGTH_NVM + $LENGTH_CONTEXT + $LENGTH_MESSAGE + $LENGTH_PATH ))
}

#======================================================================================================================#
#                                                  Prompt Componentes                                                  #
#======================================================================================================================#

function battery_content {
	local pct battery_segment
	if [[ -n $IS_LAPTOP ]]; then
		if battery_is_charging; then
			battery_segment="$GREEN_FG$BATTERY_CHARGING"
		elif plugged_in; then
			battery_segment="$GREEN_FG$PLUG_CHAR"
		else
			pct=$(battery_pct)
			if [ $pct -gt 95 ]; then
				battery_segment="$GREEN_FG$BATTERY_100"
			elif [ $pct -gt 74 ]; then
				battery_segment="$GREEN_FG$BATTERY_75"
			elif [[ $pct -gt 49 ]]; then
				battery_segment="$YELLOW_FG$BATTERY_50"
			elif [[ $pct -gt 24 ]]; then
				battery_segment="$RED_FG$BATTERY_25"
			else
				battery_segment="$RED_BL$BATTERY_0"
			fi
		fi
	fi
	battery_segment+=$BLUE_FG
	echo -n $battery_segment
}

function time_content {
	local p_time

	[[ $(date "+ %H") -gt 16 ]] && p_time=$RED_BG
	if [[ -n $MILITARY_TIME ]]; then
		 p_time+=" %T"
		 LENGTH_TIME=6
	else
		p_time+=" %t"
		LENGTH_TIME=8
	fi
	echo -n "$p_time "
}

function context_content {
	#------------------------------------------------------------------------------------------------------------------#
	#                                                  Username@hostname                                               #
	#------------------------------------------------------------------------------------------------------------------#
	#_____________________________________________ Possible Customizations ____________________________________________#
	#                     Variable                                                Valid Values                         #
	# ..................................................        ...................................................... #
	#   DEFAUT_USER                                                your regular username it must be exact so if your   #
	#                                                              not sure usewhoami to get it right                  #
	#------------------------------------------------------------------------------------------------------------------#
	#...................................................Explanation!...................................................#
	# %([x]|[true]|[false]) - Specifies a ternary expression. The character following the [x] is arbitrary; the same   #
	#                           character is used to separate the text for the [true] result from that for the [false] #
	#                           result. This separator may not appear in the [true], except as part of a %-escape      #
	#                           sequence. A ')' may appear in the [false] as '%)'. [true] and [false] may both contain #
	#                           arbitrarily nested escape sequences,# including further ternary expressions.           #
	# !                     - True if the shell  is  running  with  privileges.                                        #
	# @                     - literal '@' character                                                                    #
	# %m                    - The hostname up to the first '.'. An integer may follow the '%' to specify how many      #
	#                           components of the hostname are desired. With a negative integer, trailing components   #
	#                           of the hostname are shown.                                                             #
	#------------------------------------------------------------------------------------------------------------------#
	local user

	user=$(whoami)

	# only populate username@hostname for users that aren't default and local
	if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
		echo -n " %(!|$user:u|$user)@%m "
	fi
	
}

function path_content {
	#------------------------------------------------------------------------------------------------------------------#
	#                                             Present Working Directory                                            #
	#------------------------------------------------------------------------------------------------------------------#
	#...................................................Explanation!...................................................#
	# %$path_len - The numeric argument specifies the maximum permitted length of the various strings that can be      #
	#                displayed in the prompt.                                                                          #
	#   <...<    - Specifies truncation behaviour for the remainder of the prompt string. The '...' will be displayed  #
	#                in place of the truncated portion. Either '<' or '>' works, '<' truncates at the left, '>'        #
	#                truncates at the right.                                                                           #
	#    %~      - Present working directory ($PWD), but if $PWD has a named directory as its prefix, that part is     #
	#                replaced by a '~' followed by the name of the directory. If it starts with $HOME, that part is    #
	#                replaced by '~'.                                                                                  #
	#    %<<     - A truncation  with  argument zero marks the end of the range of the string to be truncated while    #
	#                turning off truncation from there on.                                                             #
	#------------------------------------------------------------------------------------------------------------------#
	local prompt_len max_path_len

	prompt_len=$(get_prompt_len)

	if [[ "$prompt_len + $pwd_len" -gt $termwidth ]]; then
		max_path_len=$(($termwidth - $prompt_len))
	fi

	[[ -n $max_path_len ]] && LENGTH_PATH=$(( $max_path_len - 2 )) || LENGTH_PATH=$(( $pwd_len + 2 ))

	echo -n " %$max_path_len<...<%~%<< "
}

function nvm_content {
	# shellcheck disable=SC2091
	$(type nvm >/dev/null 2>&1) || return
	
	local nvm_status

	nvm_status=$(nvm current 2>/dev/null)
	[[ "${nvm_status}" == "system" ]] && return
	[[ "${nvm_status}" == "$SYSTEM_NODE" ]] && return

	LENGTH_NVM=$(( ${#${nvm_status:-}} + 4 ))
	nvm_status="${NODE_SYMBOL} ${nvm_status} "
	
	echo -n $nvm_status
}

function message_content {
	local message
	[[ -n $ENV_MESSAGE ]] && message=$ENV_MESSAGE || message=" Smile! "
	LENGTH_MESSAGE=$(( ${#${message:-}} + 1 ))
	
	echo -n $message$RESET_COLOR$BLUE_FG$SOLID_SEPARATOR_LEFT
	
}

function divider_content {
	local divider_len divider divider_center second_line

	divider_len=$(( $termwidth - ($(get_prompt_len) + 4) ))
	divider_center="\${(l.$divider_len..${PR_HBAR}.)}"
	second_line="\${(l.(($termwidth - 1)).. .)}"
	
	divider="$PR_SHIFT_IN$PR_HBAR$PR_HBAR$divider_center$PR_HBAR$PR_URCORNER\n$PR_VBAR$second_line$PR_VBAR$PR_SHIFT_OUT"

	echo -n "${(e)divider}" 
	echo -n $'\n'$PR_SHIFT_IN$PR_LLCORNER$PR_HBAR$PR_SHIFT_OUT
}

function history_content {
	echo -n " %h "
}

function status_content {
	# Status:
	# - was there an error
	# - am I root
	# - are there background jobs?
	symbols=()

	[[ $RETVAL -ne 0 ]] && symbols+=("%{%F{red}%}${CROSS_CHAR}")
	[[ $UID -eq 0 ]] && symbols+=("$RED_BL$SUPERMAN$RESET_COLOR%{%K{black}%F{white}%}")
	[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+=("$GEAR_CHAR")

	if [[ -n "$symbols" ]]; then
		echo -n "$symbols "
	fi
}

## Main prompt
function build_prompt {
	RETVAL=$?

	local termwidth pwd_len
	get_lengths
	create_segments
  
	# Build the actual prompt
	prompt_segment $SEGMENT_START none blue
	prompt_segment $SEGMENT_TIME blue white
	prompt_segment $SEGMENT_BATTERY white
	[[ -n $SEGMENT_NVM ]] && prompt_segment $SEGMENT_NVM magenta white
	[[ -n $SEGMENT_CONTEXT ]] && prompt_segment $SEGMENT_CONTEXT green white
	prompt_segment $SEGMENT_PATH cyan white
	prompt_segment $SEGMENT_MESSAGE blue white
	prompt_segment $SEGMENT_DIVIDER none blue
	prompt_segment $SEGMENT_HISTORY blue white
	[[ -n $SEGMENT_STATUS ]] && prompt_segment $SEGMENT_STATUS none none
	prompt_segment $SEGMENT_END none none
}

#-------------------------------------------------- assign the prompt --------------------------------------------------
# shellcheck disable=SC2034
PROMPT='%{%f%b%k%}$(build_prompt)'

#======================================================================================================================#
#                                                R I G H T   P R O M P T                                               #
#======================================================================================================================#

function prompt_segment_right {
  local segment bg fg separator
  segment=${1:- }
  bg=${2:-$CURRENT_BG}
  fg=${3:-$CURRENT_FG}
  separator=${4:-NONE}

  if [[ $separator == "LINE" && $bg == $CURRENT_BG ]]; then
    echo -n $LINE_SEPARATOR_RIGHT$segment
  elif [[ $separator == "LINE" || $CURRENT_BG == "NONE" ]]; then
    echo -n "%{%F{$fg}%K{$bg}%}$segment"
  elif [[ $CURRENT_BG == $bg && $separator == "SOLID" ]]; then
    echo -n $segment
  elif [[ $separator == "SOLID" ]]; then
    echo -n "%{%F{$bg}%K{$CURRENT_BG}%}%{%F{$fg}%K{$bg}%}$segment"
  else
    echo -n "%{%F{$fg}%K{$bg}%}$segment"
  fi
  CURRENT_BG=$bg
  CURRENT_FG=$fg
}

#------------------------------------------------ Right prompt Git info ------------------------------------------------
function prompt_git_dirty_clean {
    if [[ $GIT_STAGED -gt 0 || $GIT_CHANGED -gt 0 || $GIT_UNTRACKED -gt 0 || $GIT_CONFLICTS -gt 0 ]]; then
      prompt_segment_right $DIRTY_CHAR yellow black SOLID
    else
      prompt_segment_right $CLEAN_CHAR green white SOLID
    fi
}

function prompt_git_branch_sha {
  local ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [[ -n $ref ]]; then
    prompt_segment_right " %{%B%}$BRANCH_CHAR%{%b%}" blue red SOLID
  else
    prompt_segment_right "$DETACHED_CHAR" blue white SOLID
  fi
  prompt_segment_right "$GIT_BRANCH " blue white
}

function prompt_git_ahead_behind {
  if [[ $GIT_AHEAD -gt 0 ]]; then
    prompt_segment_right "$ARROW_UP_CHAR$GIT_AHEAD " yellow white SOLID
  elif [[ $GIT_BEHIND -gt 0 ]]; then
    prompt_segment_right "$BLACK_BL$ARROW_DOWN_CHAR$GIT_BEHIND $RESET_COLOR" red black SOLID
  fi
}

function prompt_git_trafic_light {
  local light_segment
  if [[ $GIT_CONFLICT -gt 0 ]]; then
    light_segment="%{%F{red}%}$CONFLICT_CHAR"
  fi
  if [[ $GIT_UNTRACKED -gt 0 ]]; then
    light_segment="$light_segment%{%F{yellow}%}$UNTRACKED_CHAR"
  fi
  if [[ $GIT_CHANGED -gt 0 ]]; then
    light_segment="$light_segment%{%F{yellow}%}$CHANGED_CHAR"
  fi
  if [[ $GIT_STAGED -gt 0 ]]; then
    light_segment="$light_segment%{%F{green}%}$STAGED_CHAR"
  fi
  if [[ -n $light_segment ]]; then
    prompt_segment_right $light_segment white black SOLID
  fi
}

function prompt_git_mode {
  if [[ -e "${repo_path}/BISECT_LOG" ]]; then
    prompt_segment_right $BISECT_LOG_CHAR red white SOLID
  elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
    prompt_segment_right $MERGE_CHAR red white SOLID
  elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
    prompt_segment_right $REBASE_CHAR red white SOLID
  else
    prompt_segment_right $GIT_CHAR black white SOLID
  fi
}

function prompt_git {
  repo_path=$(git rev-parse --git-dir 2>/dev/null)
  # shellcheck source=/Users/jonathan/.oh-my-zsh/plugins/git-prompt/git-prompt.plugin.zsh
  source "$HOME/.oh-my-zsh/plugins/git-prompt/git-prompt.plugin.zsh"
  update_current_git_vars
  if [[ -n $GIT_BRANCH ]]; then
    prompt_segment_right "" default default
    prompt_git_dirty_clean
    prompt_git_branch_sha
    prompt_git_ahead_behind
    prompt_git_trafic_light
    prompt_git_mode
  fi
}

function prompt_vi {
  local MODE_INDICATOR="$(prompt_segment_right $LEFT_SHIFT default red SOLID)"
  echo -n "$(vi_mode_prompt_info)"
}

function build_rprompt {
	CURRENT_BG="NONE"
	CURRENT_FG="NONE"
	prompt_vi
	prompt_git
	prompt_segment_right $PR_SHIFT_IN$PR_HBAR$PR_LRCORNER$PR_SHIFT_OUT none blue NONE
}

RPROMPT='%{%f%b%k%} $(build_rprompt)'

  PS2='$CYAN$CH_SHIFT_IN$CH_HBAR$CH_SHIFT_OUT\
  $BLUE$CH_SHIFT_IN$CH_HBAR$CH_SHIFT_OUT(\
    $GREEN%_$BLUE)$CH_SHIFT_IN$CH_HBAR$CH_SHIFT_OUT\
$CYAN$CH_SHIFT_IN$CH_HBAR$CH_SHIFT_OUT$RESET_COLOR '
