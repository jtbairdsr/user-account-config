#!/bin/bash
osascript -e 'tell application "iTunes" to if player state is playing then name of current track & " - " & artist of current track'
