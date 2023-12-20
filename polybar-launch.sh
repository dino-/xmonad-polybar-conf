#! /usr/bin/env bash

# Terminate already running bar instances
polybar-msg cmd quit

# Launch the bar
polybar > $HOME/var/log/polybar.log 2>&1 & disown
# polybar -l trace > $HOME/var/log/polybar.log 2>&1 & disown
