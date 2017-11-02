#!/bin/bash
#==============================================================================#
#                               U T I L I T I E S                              #
#==============================================================================#
function clear_errors {
  return 0
}

function prompt_segment {
	echo -n "%{%F{$2}%}[ $1 ]%{%f%}"
}

function get_lengths {
	local status_len context_len message_len time_len battery_len user
	(( termwidth = COLUMNS - 2 ))
	user=$(whoami)
	if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
		(( context_len = ${#${(%):-%n@%m}} + 4 ))
	else
		context_len=0
	fi
	(( message_len = ${#ENV_MESSAGE:-Smile!} + 4 ))
	time_len=9
	status_len=13
	battery_len=8
	(( prompt_len = context_len + message_len + time_len + battery_len + status_len ))
	pwd_len=${#${(%):-%~}}
}

export MILITARY_TIME=true

#==============================================================================#
#                             L E F T   P R O M P T                            #
#==============================================================================#

function prompt_battery {
	local pct
	if [[ -n "$IS_LAPTOP" ]]; then
		pct="$(battery_pct)"
		# if ! plugged_in; then
			if battery_is_charging | [ "$pct" -gt 75 ]; then
				prompt_segment "$pct%%" green
			elif [[ "$pct" -gt 25 ]]; then
				prompt_segment "$pct%%" yellow
			else
				prompt_segment "$pct%%" red
			fi
		# fi
	fi
}

function prompt_time {
	local p_time
	[[ -n $MILITARY_TIME ]] && p_time="%T" || p_time="%t"
	[[ $(date "+ %H") -gt 16 ]] && prompt_segment "$p_time" red || prompt_segment "$p_time" blue
}

function prompt_context {
	local user
	user="$(whoami)"
	# only populate username@hostname for users that aren't default and local
	if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
		prompt_segment "%{%F{yellow}%}%(!|$user:u|$user)@%m |%{%F{magenta}%}| $(prompt_path)" yellow
	else
		prompt_segment "$(prompt_path)" cyan
	fi
}

function prompt_path {
	local path_len
	if [[ "$prompt_len + $pwd_len" -gt $termwidth ]]; then
		((path_len = termwidth - prompt_len))
	fi
	echo -n "%$path_len<...<%~%<<"
}

function prompt_message {
	local message
	[[ -n "$ENV_MESSAGE" ]] && message="$ENV_MESSAGE" || message="Smile!"
	prompt_segment "$message" blue
}

function prompt_status {
	# Status:
	# - was there an error
	# - am I root
	# - are there background jobs?
	symbols=()

	[[ $RETVAL -ne 0 ]] && symbols+=(" %{%F{red}%}X %{%F{white}%}|")
	[[ $UID -eq 0 ]] && symbols+=(" %{%F{red}%}! %{%F{white}%}|")
	[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+=(" %{%F{red}%}%(1j.%j.) bg %{%F{white}%}|")

	echo -n $'\n  '
	# shellcheck disable=SC2128
	[[ -n "$symbols" ]] && echo -n "%{%K{black}%F{white}%}|$symbols%{%f%k%}"
}

function prompt_end {
	# The char that directly proceeds user imput
	echo -n "%{%k%}→%{%f%} "
}

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

export PROMPT='%{%f%b%k%} $(build_prompt)'
#==============================================================================#
#                            R I G H T   P R O M P T                           #
#==============================================================================#

#---------------------------- Right prompt Git info ----------------------------
function prompt_git_dirty_clean {
	if [[ $GIT_STAGED -gt 0 || $GIT_CHANGED -gt 0 || $GIT_UNTRACKED -gt 0 || $GIT_CONFLICTS -gt 0 ]]; then
		prompt_segment "±" yellow
	else
		prompt_segment "✔" green
	fi
}

function prompt_git_branch_sha {
	local ref symbol
	ref=$(git symbolic-ref HEAD 2> /dev/null)
	if [[ -n $ref ]]; then
		symbol="%{%B%F{red}%}on %{%b%F{blue}%}"
	else
		symbol="%{%B%F{red}%}det. at %{%b%F{blue}%}"
	fi
	prompt_segment "$symbol$GIT_BRANCH" blue
}

function prompt_git_ahead_behind {
	if [[ $GIT_AHEAD -gt 0 ]]; then
		prompt_segment "↑ $GIT_AHEAD " yellow
	elif [[ $GIT_BEHIND -gt 0 ]]; then
		prompt_segment "↓ $GIT_BEHIND" red
	fi
}

function prompt_git_trafic_light {
	local light_segment=""
	if [[ $GIT_CONFLICTS -gt 0 ]]; then
		light_segment="%{%F{red}%}✖ "
	fi
	if [[ $GIT_UNTRACKED -gt 0 ]]; then
		light_segment="$light_segment%{%F{yellow}%}… "
	fi
	if [[ $GIT_CHANGED -gt 0 ]]; then
		light_segment="$light_segment%{%F{yellow}%}✚ "
	fi
	if [[ $GIT_STAGED -gt 0 ]]; then
		light_segment="$light_segment%{%F{green}%}● "
	fi
	if [[ -n $light_segment ]]; then
		prompt_segment $light_segment
	fi
}

function prompt_git_mode {
	if [[ -e "${repo_path}/BISECT_LOG" ]]; then
		prompt_segment "bisect" red
	elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
		prompt_segment "merge" red
	elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
		prompt_segment "rebase" red
	fi
}

function rprompt_git {
	repo_path=$(git rev-parse --git-dir 2>/dev/null)
	# shellcheck source=/Users/jonathan/.oh-my-zsh/plugins/git-prompt/git-prompt.plugin.zsh
	source "$HOME/.oh-my-zsh/plugins/git-prompt/git-prompt.plugin.zsh"
	update_current_git_vars
	if [[ -n $GIT_BRANCH ]]; then
		prompt_git_dirty_clean
		prompt_git_branch_sha
		prompt_git_ahead_behind
		prompt_git_trafic_light
		prompt_git_mode
	fi
}

function rprompt_vi {
	echo -n "$(vi_mode_prompt_info)"
}

function build_rprompt {
	rprompt_vi
	rprompt_git
}

export RPROMPT='%{%f%b%k%} $(build_rprompt)'
