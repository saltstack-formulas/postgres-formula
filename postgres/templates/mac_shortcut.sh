#!/usr/bin/env bash

vendor=$1
app="postgres.app"
Source="/Applications/$app"
Destination="{{ homes }}/{{ user }}/Desktop"
/usr/bin/osascript -e "tell application \"Finder\" to make alias file to POSIX file \"$Source\" at POSIX file \"$Destination\""

