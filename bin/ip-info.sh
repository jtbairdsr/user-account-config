#!/bin/bash

IP="$(ipconfig getifaddr en0)"
PUB_IP="$(dig +short myip.opendns.com @resolver1.opendns.com)"


echo -n "$IP  $PUB_IP"

INTERNET=" "

internet_info=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep agrCtlRSSI | awk '{print $2}' | sed 's/-//g')

if [[ "$internet_info" -lt 20 ]]; then
    echo -n '#[fg=red]'
    echo "$INTERNET"
elif [[ "$internet_info" -lt 30 ]]; then
    echo -n '#[fg=yellow]'
    echo "$INTERNET"
else
    echo -n '#[fg=green]'
    echo "$INTERNET"
fi
