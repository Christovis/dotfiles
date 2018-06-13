#!/bin/bash

# Specifying the icon(s) in the script
# This allows us to change its appearance conditionally
icon=""

running="false"
pgrep -x redshift &> /dev/null
if [[ "$?" -eq "0" ]]; then
    running="true"
fi

temp=`analyse-gamma | grep temperature: | awk 'NR==1{ print $NF }'`

if [[ "$running" != "true" ]]; then
    echo " %{F#83D0C9}$icon${temp}%{F#e8d174}K"       # Blue out (not running)
elif [[ $temp -ge 5000 ]]; then
    echo " %{F#42A5F5}$icon${temp}%{F#e8d174}K"
elif [[ $temp -ge 4000 ]]; then
    echo " %{F#EBCB8B}$icon${temp}%{F#e8d174}K"
else
    echo " %{F#FF9800}$icon${temp}%{F#e8d174}K"
fi
