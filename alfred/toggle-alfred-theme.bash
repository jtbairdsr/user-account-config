#!/bin/bash -e

# Wrapper for the toggle_alfred_theme.py script at
# https://gist.github.com/deanishe/ce442c3a768adedc9c39
# (where this script also comes from)
#
# The purpose of this wrapper is to enable you to update the Python script
# without having to edit the script to change the settings each time. You keep
# them in here instead, and this script should hopefully prove dumb enough
# to require little updating...
#
# This script assumes it is in the same directory as toggle_alfred_theme.py.
# If it isn't, set PYTHON_SCRIPT_PATH below to the full path of
# toggle_alfred_theme.py

PYTHON_SCRIPT_PATH=

# ---------------------------------------------------------
# Location

# Change these settings to match your location. You can get the
# latitude, longitude and elevation from the Wikipedia page for
# your town/city.
# TZ_NAME must be one of the timezones understood by `pytz`
# Run this script with the option --timezones to see a list.
export CITY=Rexburg
export COUNTRY=United States
export LATITUDE=43.816667
export LONGITUDE=-111.783333
export TZ_NAME=US/Mountain
export ELEVATION=1483  # In metres!


# ---------------------------------------------------------
# Default themes

# You can override these settings on the command line with the
# --light and --dark options
export LIGHT_THEME="Solarized Yosemite (Light)"
export DARK_THEME="Solarized Yosemite (Dark)"

# Python interpreter to run toggle_alfred_theme.py with (when called from the
# Launch Agent). If you want to use a Homebrew Python, change this to
# `/usr/local/bin/python`
# When you install the script, ensure it works with this Python interpreter.
export PYTHON_INTERPRETER=/usr/bin/python

# Pause after reloading the Launch Agent. If the script appears
# to be constantly running on your machine, increase this number
export PAUSE_AFTER_RELOAD=3

# Set to 1 to capture STDOUT/STDERR of Launch Agent and set
# DEBUG logging level. The output of STDOUT & STDERR are saved to
# net.deanishe.alfred-toggle-theme.launch-agent.stdXXX.log files
# in ~/Library/Logs, alongside the log file.
export DEBUG=0


###########################################################
# Don't edit below unless you know what you're doing
###########################################################

# Assume toggle_alfred_theme.py is in the same directory as this script
if [[ -z "${PYTHON_SCRIPT_PATH}" ]]; then
	PYTHON_SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/toggle_alfred_theme.py"
fi

"${PYTHON_INTERPRETER}" "${PYTHON_SCRIPT_PATH}" "$@"
