#! /usr/bin/env bash

set -e

xmonadDir="$HOME/.xmonad"
polybarConfDir="$HOME/.config/polybar"
install --directory "$polybarConfDir"
ln --force --symbolic "$xmonadDir/polybar-config.ini" "$polybarConfDir/config.ini"
ln --force --symbolic "$xmonadDir/polybar-launch.sh" "$polybarConfDir/launch.sh"
install --directory "$HOME/var/log"
