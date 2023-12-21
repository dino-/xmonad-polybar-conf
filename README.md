# xmonad-polybar config


## Synopsis

My personal xmonad and polybar configuration (Haskell)


## Description

Because I use them together, I keep the configuration for both
xmonad and polybar in the same `.xmonad` directory. This is a repo
of my work on these files.


## Getting it

To use this software, some packages must be installed

For basic operation, these are required

- xmonad          # The xmonad window manager
- xmonad-contrib  # Additional xmonad libs, layouts, etc..
- polybar         # The status bar
- xmonad-dbus     # For EWMH integration between polybar and xmonad

Optional but useful

- blueberry               # For bluetooth, also includes a tray icon
- network-manager-applet  # For the tray, if you use NetworkManager
- pavucontrol             # PulseAudio mixer, right-click on VOL to launch
- rofi                    # Fancy app launcher, does a lot more

Tray applets need to be started from somewhere, like an ~/.xinitrc X start
script. Probably after the window manager is started but before the script
enters the waiting phase.

    ...
    bluetooth-tray &
    nm-applet &
    ...

If you want to use this repo as-is, not just for inspiration, it's
intended to be cloned into the customary `.xmonad` dot-directory. A script can
be run to create directories and create symlinks, for polybar and possibly more
tools.

    $ cd
    $ git clone https://github.com/dino-/xmonad-polybar-conf.git .xmonad
    $ cd .xmonad
    $ ./install.sh

The polybar config will be placed in `~/.config/polybar/config.ini`

When making changes, it may be useful to watch the log for errors or info. It
will be overwritten every time xmonad is restarted (with mod-q, which will also
restart polybar).

    $ tail -f ~/var/log/polybarlog


## Build issues

### xmonad

Around 2017-06-26 I experienced a build failure on Arch Linux with
stale libraries in the default, systemwide ghc. There were linker
errors in the `xmonad.errors` build log. Some searching brought
me to [this page](https://bugs.archlinux.org/task/54561) and it
may be good to keep this around, an "emergency" dynamic binary
compilation command:

    $ cd ~/.xmonad
    $ ghc --make xmonad.hs -i -ilib -dynamic -fforce-recomp -main-is main -v0 -o xmonad-x86_64-linux


## Contact

Dino Morelli <[dino@ui3.info](mailto:dino@ui3.info)>
