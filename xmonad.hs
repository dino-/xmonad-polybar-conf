--
-- Dino's xmonad config file.
--

-- Conventional imports
import qualified Data.Map as M
import System.Exit (exitSuccess)
import XMonad
import qualified XMonad.StackSet as W

-- Added by Dino
import System.FilePath ((</>), (<.>))
import Text.Printf (printf)
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageDocks
   (ToggleStruts (..), avoidStruts, docks, manageDocks)
import XMonad.Hooks.ManageHelpers
   -- ((-?>), composeOne, doCenterFloat, isDialog, transience)
   ((-?>), composeOne, isDialog, transience)
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Layout.MultiColumns (multiCol)
import XMonad.Layout.Tabbed (simpleTabbed)
import XMonad.Layout.ThreeColumns (ThreeCol (ThreeCol, ThreeColMid))
import XMonad.Prompt (XPPosition (Top), alwaysHighlight, font,
   position, promptBorderWidth)
import XMonad.Prompt.ConfirmPrompt (confirmPrompt)
import XMonad.Prompt.Shell (shellPrompt)
-- import XMonad.Util.SpawnOnce (spawnOnce)


-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "st"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
--myModMask = mod1Mask
myModMask = mod4Mask  -- The Windows logo key

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
--myFocusedBorderColor = "#ff0000"  -- red - default
--myFocusedBorderColor = "#ffff00"  -- yellow
myFocusedBorderColor = "#00ff00"  -- green

--------------------------------------------------------------------------------
-- | Customize the way 'XMonad.Prompt' looks and behaves.  It's a
-- great replacement for dzen.
myXPConfig = def
  { position          = Top
  , alwaysHighlight   = True
  , promptBorderWidth = 0
  -- , font              = "xft:monospace:size=9"
  , font              = "xft:DejaVuSansMono:size=9"
  }

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    --, ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch gmrun
    -- 2021-03-31 Don't have gmrun installed at this time
    -- , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    -- 2021-03-31 This doesn't seem to do anything, commenting it out
    -- , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm .|. shiftMask, xK_Tab   ), windows W.focusUp)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    -- , ((modm .|. shiftMask, xK_q     ), io exitSuccess)

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))


    -- Added by Dino

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), confirmPrompt myXPConfig "exit" (io exitSuccess))

    -- launch xscreensaver-command -lock
    , ((modm .|. shiftMask, xK_l     ), spawn "xscreensaver-command -lock")

    -- launch xscreensaver-command -lock AND power the monitor down
    , ((modm .|. controlMask, xK_l   ), spawn "xscreensaver-command -lock; sleep 1; xset dpms force off")

    -- launch XMonad app prompt
    , ((modm .|. shiftMask, xK_p     ), shellPrompt myXPConfig)

    -- app launcher
    , ((modm,               xK_p     ), spawn "rofi -show-icons -show drun")

    -- Mouse button pressing and holding. Note: xte is in arch package xautomation
    , ((modm              , xK_F1    ), spawn "xte 'usleep 500000' 'mouseclick 1'")  -- left mouse button click
    , ((modm .|. shiftMask, xK_F1    ), spawn "xte 'mousedown 1'")  -- left mouse button lock
    , ((modm              , xK_F2    ), spawn "xte 'usleep 500000' 'mouseclick 2'")  -- middle mouse button click
    , ((modm              , xK_F3    ), spawn "xte 'usleep 500000' 'mouseclick 3'")  -- right mouse button click

    -- Fetch email
    , ((modm .|. controlMask, xK_m   ), spawn "notify-send 'Checking email...'; mailctl sync")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        -- This is normal
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        -- Swapped w and e because of confusion between nVidia settings for primary and what xmonad sees from xinerama/xrandr
        -- | (key, sc) <- zip [xK_e, xK_w, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                      >> windows W.shiftMaster)

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w
                                      >> windows W.shiftMaster)

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts $
   tiled |||
   Mirror tiled |||
   Full |||
   multiCol [1] 1 0.01 (-0.5) |||  -- Many equal columns!
   ThreeCol nmaster delta (1/3) |||  -- Three equal columns with resizing
   ThreeColMid nmaster delta ratio |||
   simpleTabbed
   where
      -- default tiling algorithm partitions the screen into two panes
      tiled   = Tall nmaster delta ratio

      -- The default number of windows in the master pane
      nmaster = 1

      -- Default proportion of screen occupied by master pane
      ratio   = 1/2

      -- Percent of screen to increment by when resizing panes
      delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = manageDocks <+> composeOne
  -- None of these apps are installed on my system now
  [ className =? "Godot"  -?> doFloat

  -- Not sure what these used to do
  --, resource  =? "desktop_window" --> doIgnore
  --, resource  =? "kdesktop"       --> doIgnore

  , isDialog -?> doFloat

  -- Move transient windows to their parent:
  , transience
  ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
--myEventHook = mempty
myEventHook = handleEventHook def

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
-- myStartupHook = return ()
myStartupHook = do
  let xmonadDir = "~" </> ".xmonad"

  -- 2020-05-11 Added specifically because of the black window contents problem
  -- with Java Swing apps
  setWMName "LG3D"

  -- polybar status bar

  -- Make sure no other polybar instances are running
  spawn "polybar-msg cmd quit"

  -- Can tail this log file in a terminal
  let polybarLogPath = xmonadDir </> "polybar" <.> "log"
  let polybarConfPath = xmonadDir </> "polybar-config" <.> "ini"

  spawn $ printf "polybar --config=%s > %s 2>&1" polybarConfPath polybarLogPath

  -- For debugging, more info in the log
  -- spawn $ printf "polybar --config=%s --log=trace > %s 2>&1" polybarConfPath polybarLogPath

  -- Tray applets started here
  spawn "nm-applet"  -- If you use NetworkManager, package network-manager-applet
  spawn "blueman-applet"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

main :: IO ()
main = xmonad $ ewmhFullscreen . ewmh . docks $ defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- | They keybindings for this config file, accessible via mod-Shift-/
help :: String
help = unlines
   [ "XMonad keybindings help"
   , ""
   , "The modifier key is 'super'. Keybindings:"
   , ""
   , "-- launching and killing programs"
   , "mod-Shift-Enter  Launch " ++ myTerminal
   , "mod-p            rofi app launcher"
   , "mod-Shift-p      xmonad built-in app launcher"
   , "mod-Shift-c      Close/kill the focused window"
   , "mod-Space        Rotate through the available layout algorithms"
   , "mod-Shift-Space  Reset the layouts on the current workSpace to default"
   -- , "mod-n            Resize/refresh viewed windows to the correct size"
   , "mod-Shift-l      Lock workstation with xscreensaver"
   , "mod-Ctrl-l       Lock workstation with xscreensaver and power monitors down"
   , "mod-Ctrl-m       Fetch email"
   , ""
   , "-- move focus up or down the window stack"
   , "mod-Tab        Move focus to the next window"
   , "mod-Shift-Tab  Move focus to the previous window"
   , "mod-j          Move focus to the next window"
   , "mod-k          Move focus to the previous window"
   , "mod-m          Move focus to the master window"
   , ""
   , "-- modifying the window order"
   , "mod-Return   Swap the focused window and the master window"
   , "mod-Shift-j  Swap the focused window with the next window"
   , "mod-Shift-k  Swap the focused window with the previous window"
   , ""
   , "-- resizing the master/slave ratio"
   , "mod-h  Shrink the master area"
   , "mod-l  Expand the master area"
   , ""
   , "-- floating layer support"
   , "mod-t  Push window back into tiling; unfloat and re-tile it"
   , ""
   , "-- increase or decrease number of windows in the master area"
   , "mod-comma  (mod-,)  Increment the number of windows in the master area"
   , "mod-period (mod-.)  Deincrement the number of windows in the master area"
   , ""
   , "-- quit, or restart"
   , "mod-Shift-q  Quit xmonad"
   , "mod-q        Restart xmonad"
   , ""
   , "-- Workspaces & screens"
   , "mod-[1..9]         Switch to workSpace N"
   , "mod-Shift-[1..9]   Move client to workspace N"
   , "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3"
   , "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3"
   , ""
   , "-- Mouse bindings: actions that are bound to or generate mouse events"
   , "mod-button1   Set the window to floating mode and move by dragging left mouse button"
   , "mod-button2   Raise the window to the top of the stack (middle button click)"
   , "mod-button3   Set the window to floating mode and resize by dragging right mouse button"
   , "mod-F1        Left mouse button click (button 1)"
   , "mod-Shift-F1  Left mouse button lock (button 1)"
   , "mod-F2        Middle mouse button click (button 2)"
   , "mod-F3        Right mouse button click (button 3)"
   , ""
   , "-- Miscellaneous bindings"
   , "mod-b                Toggle the status bar gap"
   , "mod-Shift-/ (mod-?)  Show this help dialog"
   ]
