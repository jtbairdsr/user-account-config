#!/bin/bash
#==============================================================================#
#                              Set Color Variables                             #
#==============================================================================#

autoload colors && colors

# shellcheck disable=SC2034
{
# shellcheck source=colors
RESET_COLOR="%{$reset_color%}"
#------------------------------ Set Basic Colors -------------------------------
#................................. background ..................................
RED_BG="%{$bg[red]%}"
GREEN_BG="%{$bg[green]%}"
YELLOW_BG="%{$bg[yellow]%}"
BLUE_BG="%{$bg[blue]%}"
MAGENTA_BG="%{$bg[magenta]%}"
CYAN_BG="%{$bg[cyan]%}"
WHITE_BG="%{$bg[white]%}"
BLACK_BG="%{$bg[black]%}"

WHITE_BL="%{\033[5;37m%}"
BLACK_BL="%{\033[5;30m%}"
RED_BL="%{\033[5;31m%}"

}

#==============================================================================#
#                          Cool Character Variables                            #
#==============================================================================#
SOLID_SEPARATOR_RIGHT="\ue0b2" # 
LINE_SEPARATOR_RIGHT="\ue0b3"  # 
SOLID_SEPARATOR_LEFT="\ue0b0"  # 
LINE_SEPARATOR_LEFT="\ue0b1"   # 

PLUG_CHAR=" \uf1e6"            # 
BATTERY_0=" \uf244"            # 
BATTERY_25=" \uf243"           # 
BATTERY_50=" \uf242 "          # 
BATTERY_75=" \uf241 "          # 
BATTERY_100=" \uf240 "         # 
BATTERY_CHARGING=" \uf0e7"     # 

GIT_CHAR=" \uf1d3 "            # 
DETACHED_CHAR=" \uf417 "       # 
BRANCH_CHAR=" \uf418 "         # 
MERGE_CHAR=" \uf419 "          # 
REBASE_CHAR=" \uf47f "         # 
BISECT_LOG_CHAR=" \uf46f "     # 
UNTRACKED_CHAR=" \u2026 "      # …
CHANGED_CHAR=" \u271a "        # ✚
CONFLICTS_CHAR=" \uf00d "      # 
STAGED_CHAR=" \u25cf "         # ●
CLEAN_CHAR=" \uf00c "          # 


NODE_SYMBOL=" \ue718"          # 
SUPERMAN=" \uf43b"             # 
CROSS_CHAR=" \uf00d"           # 
DIRTY_CHAR="\u00b1"            # ±
GEAR_CHAR=" \uf013 "           # 
ARROW_UP_CHAR="\uf062 "        # 
ARROW_DOWN_CHAR="\uf063 "      # 
# ON_CHAR=" \ue0a8 "             # 
ON_CHAR=" \uf418 "             # 
PROMPT_CHAR="\uf054"           # 

function check_font {
  echo "SEPARATORS"
  echo $SOLID_SEPARATOR_RIGHT$SOLID_SEPARATOR_LEFT$LINE_SEPARATOR_RIGHT$LINE_SEPARATOR_LEFT
  echo
  echo "GIT"
  echo "$GIT_CHAR$BRANCH_CHAR$MERGE_CHAR$REBASE_CHAR$BISECT_LOG_CHAR$DETACHED_CHAR$UNTRACKED_CHAR$CHANGED_CHAR$CONFLICTS_CHAR$STAGED_CHAR$CLEAN_CHAR"
  echo
  echo "POWER"
  echo "$PLUG_CHAR$PLUG_CHAR$BATTERY_0$BATTERY_25$BATTERY_50$BATTERY_75$BATTERY_100$BATTERY_CHARGING"
  echo
  echo "MISC"
  echo "$NODE_SYMBOL$SUPERMAN$CROSS_CHAR$DIRTY_CHAR$GEAR_CHAR$ARROW_UP_CHAR$ARROW_DOWN_CHAR$ON_CHAR$PROMPT_CHAR"
}
function clear_errors {
  return 0
}

CURRENT_BG="NONE"
CURRENT_FG="NONE"

#==============================================================================#
#                             L E F T   P R O M P T                            #
#==============================================================================#
#==============================================================================#
#                                   Utilities                                  #
#==============================================================================#

#------------------------------- Begin a segment -------------------------------
function prompt_segment_left {
	local segment bg fg separator
	segment=${1:- }
	bg=${2:-$CURRENT_BG}
	fg=${3:-$CURRENT_FG}
	separator=${4:-NONE}

	if [[ $separator == "LINE" && $bg == "$CURRENT_BG" ]]; then
		echo -n "$LINE_SEPARATOR_LEFT$segment"
	elif [[ $separator == "LINE" || $CURRENT_BG == "NONE" ]]; then
		echo -n "%{%F{$fg}%K{$bg}%}$segment"
	elif [[ $CURRENT_BG == "$bg" && $separator == "SOLID" ]]; then
		echo -n "$segment"
	elif [[ $separator == "SOLID" ]]; then
		echo -n "%{%F{$CURRENT_BG}%K{$bg}%}$SOLID_SEPARATOR_LEFT%{%F{$fg}%}$segment"
	else
		echo -n "%{%F{$fg}%K{$bg}%}$segment"
	fi
	CURRENT_BG=$bg
	CURRENT_FG=$fg
}

function get_lengths {
  # Determine How long the path can be and how long the divider will be
  #----------------------------------------------------------------------------#
   local status_len context_len message_len time_len battery_len user
  (( termwidth = COLUMNS - 2 ))
  user=$(whoami)
  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    (( context_len = ${#${(%):-%n@%m}} + 3 ))
  else
    context_len=0
  fi
  (( message_len = ${#ENV_MESSAGE:-Smile!} + 2 ))
  time_len=10
  status_len=13
  battery_len=10
  #............................................................................#
  #................................Explanation!................................#
  # ${[varname]:-[string]} - Returns the value of [varname] normally, but uses #
  #                            [string] instead if ${[varname]} doesn't exist. #
  #                            ${:-[string]} is a quick way to do variable     #
  #                            related things to fixed strings.                #
  # ${([flags])[varname]}  - Uses the flags to alter how the value of the      #
  #                            variable is handled. The percent sign causes    #
  #                            prompt expansion to be done on the variable. So #
  #                            ${(%):-%~} does prompt expansion on the literal #
  #                            string "%~".                                    #
  # ${#[varname]}          - Gives the length of the value of the variable. It #
  #                            appears that zsh handles the pound sign before  #
  #                            applying the (%) flag, so I had to nest the (%) #
  #                            flag in order to get things to happen in the    #
  #                            right order.                                    #
  #............................................................................#
  (( prompt_len = context_len + message_len + time_len + battery_len + status_len ))
  pwd_len=${#${(%):-%~}}
}



#==============================================================================#
#                               Prompt Componentes                             #
#==============================================================================#


function prompt_path {
  #----------------------------------------------------------------------------#
  #                          Present Working Directory                         #
  #............................................................................#
  #................................Explanation!................................#
  # %$PATH_LEN - The numeric argument specifies the maximum permitted length   #
  #                of the various strings that can be displayed in the prompt. #
  #   <...<    - Specifies truncation behaviour for the remainder of the       #
  #                prompt string. The '...' will be displayed in place of the  #
  #                truncated portion. Either '<' or '>' works, '<' truncates   #
  #                at the left, '>' truncates at the right.                    #
  #    %~      - Present working directory ($PWD), but if $PWD has a named     #
  #                directory as its prefix, that part is replaced by a '~'     #
  #                followed by the name of the directory. If it starts with    #
  #                $HOME, that part is replaced by '~'.                        #
  #    %<<     - A truncation  with  argument zero marks the end of the range  #
  #                of the string to be truncated while turning off truncation  #
  #                from there on.                                              #
  #----------------------------------------------------------------------------#
  local path_len
  if [[ "$prompt_len + $pwd_len" -gt $termwidth ]]; then
    ((path_len = termwidth - prompt_len))
  fi
  prompt_segment_left " %$path_len<...<%~%<<" white blue "$1"
}

function prompt_history {
  #----------------------------------------------------------------------------#
  #                                   History                                  #
  #............................................................................#
  #................................Explanation!................................#
  # %h          - Current history event number.                                #
  # []          - Literal retrun so the history number will be wraped in '[]'  #
  #----------------------------------------------------------------------------#
  # prompt_segment_left "[%h]" blue white SOLID
  echo -n "[%h]"
}

function prompt_context {
  #----------------------------------------------------------------------------#
  #                              Username@hostname                             #
  #............................................................................#
  #__________________________ Possible Customizations _________________________#
  #              Variable                              Valid Values            #
  # ..................................      .................................. #
  #   DEFAUT_USER                             your regular username it must    #
  #                                           be exact so if your not sure     #
  #                                           usewhoami to get it right        #
  #............................................................................#
  #................................Explanation!................................#
  # %([x]|[true]|[false]) - Specifies a ternary expression. The character      #
  #                           following the [x] is arbitrary; the same         #
  #                           character is used to separate the text for the   #
  #                           [true] result from that for the [false] result.  #
  #                           This separator may not appear in the [true],     #
  #                           except as part of a %-escape sequence. A ')' may #
  #                           appear in the [false] as '%)'. [true] and        #
  #                           [false] may both contain arbitrarily nested      #
  #                           escape sequences,# including further ternary     #
  #                           expressions.                                     #
  # !                     - True if the shell  is  running  with  privileges.  #
  # @                     - literal '@' character                              #
  # %m                    - The hostname up to the first '.'. An integer may   #
  #                           follow the '%' to specify how many components of #
  #                           the hostname are desired. With a negative        #
  #                           integer, trailing components of the hostname are #
  #                           shown.                                           #
  #............................................................................#
  local user
  user=$(whoami)
  # only populate username@hostname for users that aren't default and local
  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment_left " %(!|$user:u|$user)@%m " white blue SOLID
    prompt_path LINE
  else
    prompt_path SOLID
  fi
}

function prompt_message {
  local message
  [[ -n $ENV_MESSAGE ]] && message=$ENV_MESSAGE || message="Smile!"
  prompt_segment_left " $message" blue white SOLID
}

#------------------------------------ Time -------------------------------------
function prompt_time {
  local p_time
  [[ -n $MILITARY_TIME ]] && p_time="%T" || p_time="%t"
  prompt_segment_left " $p_time " blue white SOLID
}

#----------------------------------- Battery -----------------------------------
function prompt_battery {
	local pct
	if [[ -n $IS_LAPTOP ]]; then
		if battery_is_charging; then
			prompt_segment_left "$BATTERY_CHARGING" green white SOLID
		elif plugged_in; then
			prompt_segment_left "$PLUG_CHAR" green white SOLID
		else
			pct=$(battery_pct)
			if [[ "$pct" -gt 95 ]]; then
				prompt_segment_left "$BATTERY_100" green white SOLID
			elif [[ "$pct" -gt 74 ]]; then
				prompt_segment_left "$BATTERY_75" yellow white SOLID
			elif [[ "$pct" -gt 49 ]]; then
				prompt_segment_left "$BATTERY_50" yellow white SOLID
			elif [[ "$pct" -gt 24 ]]; then
				prompt_segment_left "$BATTERY_25" red white SOLID
			else
				prompt_segment_left "$BATTERY_0" red white SOLID
			fi
		fi
	fi
}


function prompt_status {
  # Status:
  # - was there an error
  # - am I root
  # - are there background jobs?
  symbols=()

  [[ $RETVAL -ne 0 ]] && symbols+=("%{%F{red}%}${CROSS_CHAR}")
  [[ $UID -eq 0 ]] && symbols+=("$RED_BL$SUPERMAN$RESET_COLOR%{%K{black}%F{white}%}")
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+=("$GEAR_CHAR")

  prompt_segment_left $'\n' default default SOLID
  # shellcheck disable=SC2128
  [[ -n "$symbols" ]] && prompt_segment_left "$symbols " black white LINE
}

#-------------------------------- End a segment --------------------------------
function prompt_end {
  # The char that directly proceeds user imput

  # prompt_history
  prompt_segment_left "" default default SOLID
  echo -n "%{%k%f%}"
  echo -n "$PROMPT_CHAR "
}
## Main prompt
function build_prompt {
  RETVAL=$?
  local termwidth prompt_len pwd_len
  get_lengths

  # Build the actual prompt
  prompt_battery
  prompt_time
  prompt_context
  prompt_message
  prompt_status
  prompt_end
}

# shellcheck disable=SC2034,SC2016
PROMPT='%{%f%b%k%}$(build_prompt)'

#==============================================================================#
#                            R I G H T   P R O M P T                           #
#==============================================================================#

function prompt_segment_right {
	local segment bg fg separator
	segment=${1:- }
	bg=${2:-$CURRENT_BG}
	fg=${3:-$CURRENT_FG}
	separator=${4:-NONE}

	if [[ $separator == "LINE" && $bg == "$CURRENT_BG" ]]; then
		echo -n "$LINE_SEPARATOR_RIGHT$segment"
	elif [[ $separator == "LINE" || $CURRENT_BG == "NONE" ]]; then
		echo -n "%{%F{$fg}%K{$bg}%}$segment"
	elif [[ $CURRENT_BG == "$bg" && $separator == "SOLID" ]]; then
		echo -n "$segment"
	elif [[ $separator == "SOLID" ]]; then
		echo -n "%{%F{$bg}%K{$CURRENT_BG}%}$SOLID_SEPARATOR_RIGHT%{%F{$fg}%K{$bg}%}$segment"
	else
		echo -n "%{%F{$fg}%K{$bg}%}$segment"
	fi
	CURRENT_BG=$bg
	CURRENT_FG=$fg
}

#---------------------------- Right prompt Git info ----------------------------
function prompt_git_dirty_clean {
	if [[ $GIT_STAGED -gt 0 || $GIT_CHANGED -gt 0 || $GIT_UNTRACKED -gt 0 || $GIT_CONFLICTS -gt 0 ]]; then
		prompt_segment_right "$DIRTY_CHAR" yellow black SOLID
	else
		prompt_segment_right "$CLEAN_CHAR" green white SOLID
	fi
}

function prompt_git_branch_sha {
	local ref
	ref=$(git symbolic-ref HEAD 2> /dev/null)
	if [[ -n $ref ]]; then
		prompt_segment_right " %{%B%}$ON_CHAR%{%b%}" blue red SOLID
	else
		prompt_segment_right "$DETACHED_CHAR" blue white SOLID
	fi
	prompt_segment_right "$GIT_BRANCH" blue white
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
	if [[ $GIT_CONFLICTS -gt 0 ]]; then
		light_segment="%{%F{red}%}$CONFLICTS_CHAR"
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
		prompt_segment_right "$light_segment" white black SOLID
	fi
}
function prompt_git_mode {
	if [[ -e "${repo_path}/BISECT_LOG" ]]; then
		prompt_segment_right "$BISECT_LOG_CHAR" red white SOLID
	elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
		prompt_segment_right "$MERGE_CHAR" red white SOLID
	elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
		prompt_segment_right "$REBASE_CHAR" red white SOLID
	else
		prompt_segment_right "$BRANCH_CHAR" black white SOLID
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
  echo -n "$(vi_mode_prompt_info)"
}

function build_rprompt {
  CURRENT_BG="NONE"
  CURRENT_FG="NONE"
  prompt_vi
  prompt_git
}

RPROMPT='%{%f%b%k%} $(build_rprompt)'

#   PS2='$CYAN$CH_SHIFT_IN$CH_HBAR$CH_SHIFT_OUT\
#   $BLUE$CH_SHIFT_IN$CH_HBAR$CH_SHIFT_OUT(\
#     $GREEN%_$BLUE)$CH_SHIFT_IN$CH_HBAR$CH_SHIFT_OUT\
# $CYAN$CH_SHIFT_IN$CH_HBAR$CH_SHIFT_OUT$RESET_COLOR '

# PS2='$prompt_segment_left(%_)'

PS2='$(prompt_segment_left "%_" blue white)$(prompt_segment_left)'

# vim:tabstop=4:shiftwidth=4
