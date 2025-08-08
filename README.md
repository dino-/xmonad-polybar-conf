# xmonad-polybar-conf


## Synopsis

My personal xmonad and polybar configuration (Haskell)


## Description

Because I use them together, I keep the configuration for both xmonad and
polybar in the same `.xmonad` directory. This is a repo of my work on these
files.

Prior to this I used xmobar for my status bar (for a VERY long time, starting
in 2008!) xmobar is a good, stable, flexible status bar but suffers from a
couple of limitations: 1) No tray applet support, 2) No mouse click behaviors.


## Getting it

To use this software, some packages must be installed

For basic operation, these are required

- polybar             # The status bar
- ttf-dejavu          # Main font for text/numbers
- xmonad              # The xmonad window manager
- xmonad-contrib      # Additional xmonad libs, layouts, etc..
- xmonad-dbus         # For EWMH integration between polybar and xmonad
- woff2-font-awesome  # For status bar icons

Optional but useful

- blueberry               # For bluetooth, also includes a tray icon
- network-manager-applet  # nm-applet for the tray, if you use NetworkManager
- nm-connection-editor    # Can be launched by nm-applet
- pavucontrol             # PulseAudio mixer, right-click on VOL to launch
- rofi                    # Fancy app launcher, does a lot more

If you want to use this repo as-is, not just for inspiration, it's intended to
be cloned into the customary `.xmonad` dot-directory.

    $ cd  # Your HOME directory
    $ git clone https://github.com/dino-/xmonad-polybar-conf.git .xmonad
    $ cd .xmonad

Configure things by editing `xmonad.hs` and `polybar-config.ini`

When making changes, it may be useful to watch the log for errors or info. It
will be overwritten every time xmonad is restarted (with mod-q, which will also
restart polybar).

    $ tail -f ~/.xmonad/polybar.log

On the topic of tinkering, the
[polybar wiki](https://github.com/polybar/polybar/wiki) is the documentation.


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
