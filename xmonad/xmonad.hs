import XMonad

import Data.List
import Data.Monoid

import System.Exit
import System.IO

import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName

import XMonad.Layout
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing

import XMonad.Prompt
import XMonad.Prompt.Man
import XMonad.Prompt.Shell

import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)

import qualified Data.Map        as M
import qualified XMonad.StackSet as W

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
--myTerminal      = "urxvtc -e bash"
myTerminal      = "termite -e bash"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = clickable $ ["web","2","3","4","5","6","irc","8","9"]
    where clickable l = [ "^ca(1,setxkbmap fr;xdotool key super+ampersand)web^ca()",
                          "^ca(1,setxkbmap fr;xdotool key super+eacute)2^ca()",
                          "^ca(1,setxkbmap fr;xdotool key super+quotedbl)3^ca()",
                          "^ca(1,setxkbmap fr;xdotool key super+apostrophe)4^ca()",
                          "^ca(1,setxkbmap fr;xdotool key super+parenleft)5^ca()",
                          "^ca(1,setxkbmap fr;xdotool key super+minus)6^ca()",
                          "^ca(1,setxkbmap fr;xdotool key super+egrave)irc^ca()",
                          "^ca(1,setxkbmap fr;xdotool key super+underscore)8^ca()",
                          "^ca(1,setxkbmap fr;xdotool key super+ccedilla)9^ca()"
                        ]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "white"
-- myFocusedBorderColor = "#000000"
myFocusedBorderColor = "red"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    --, ((modm,               xK_p     ), spawn "exe=`yeganesh -x` && eval \"exec $exe\"")
    , ((modm,               xK_p     ), spawn "exe=`dmenu_run -hist ~/.config/dmenu2/hist -dim 0.4` && eval \"exec $exe\"")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- launch xmenud
    , ((modm,               xK_x     ), spawn "xmenud")

    -- shell Prompt
    , ((modm .|. shiftMask, xK_x     ), shellPrompt myXPConfig)

    -- man Prompt
    , ((modm,               xK_F1    ), manPrompt myXPConfig)

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

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
    , ((modm,               xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm,               xK_semicolon), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm,               xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), spawn "/home/cgirard/shutdown.sh")

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "killall conky dzen2 && xmonad --recompile; xmonad --restart")

    -- GridSelected
    , ((modm,               xK_g     ), goToSelected defaultGSConfig)

    -- Switch next/previous workspace
    , ((modm,               xK_Right ), nextWS)
    , ((modm,               xK_Left  ), prevWS)
    , ((modm .|. shiftMask    , xK_Right), shiftToNext)
    , ((modm .|. shiftMask    , xK_Left), shiftToPrev)


    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [0x26,0xe9,0x22,0x27,0x28,0x2d,0xe8,0x5f,0xe7,0xe0]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{z,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{z,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_z, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++

    -- lock screen
    --
    --[ ((modm .|. shiftMask, xK_w), spawn "sxlock -l")]
    [ ((modm .|. shiftMask, xK_w), spawn "light-locker-command -l")]
    ++

    -- screenshots
    --
    [((controlMask, xK_Print), spawn "sleep 0.2; scrot -s -d 1"),
     ((0, xK_Print), spawn "scrot")]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

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
myLayout = spacing 3 $ avoidStruts $
       tiled ||| Mirror tiled ||| Full ||| Grid ||| simpleFloat
          where
     -- default tiling algorithm partitions the screen into two panes
             tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
             nmaster = 1

     -- Default proportion of screen occupied by master pane
             ratio   = 56/100

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
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Pidgin"       --> doF (W.shift "irc")
    , className =? "Xchat"       --> doF (W.shift "irc")
    , title =? "weechat 0.3.6"  --> doF (W.shift "irc")
    --, fmap ("Oracle" `isPrefixOf`) title   --> doF (W.shift "irc")
    , className =? "Navigator"       --> doF (W.shift "web")
    --, className =? "Thunderbird"       --> doF (W.shift "mail")
    --, className =? "Lanikai"       --> doF (W.shift "mail")
    --, className =? "Shredder"       --> doF (W.shift "mail")
    --, className =? "Miramar"       --> doF (W.shift "mail")
    --, className =? "Daily"      --> doF (W.shift "mail")
    , className =? "Gcalctool"        --> doFloat
    , className  =? "VirtualBox"        --> doFloat
    , className  =? "Xmessage"        --> doFloat
    , className  =? "Gxmessage"        --> doFloat
    , className  =? "DialogBox"        --> doFloat
    , className  =? "Steam"        --> doFloat
    , className =? "Plugin-container"  --> doFullFloat
    , resource  =? "Download"       --> doFloat
    --, resource  =? "Browser"        --> doFloat
    , resource =? "Toplevel"       --> doFullFloat
    , resource  =? "Dialog"        --> doFloat
    , title =? "KeePassHttp: Confirm Access"        --> doFloat
    --, title =? "Search and Select List of Values - Nightly"        --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]
--    , isFullscreen --> doFullFloat ]
    <+> manageDocks
    -- <+> composeOne
    --[ isFullscreen -?> (doF W.focusDown <+> doFullFloat)]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- myEventHook = mempty <+> fullscreenEventHook
myEventHook = ewmhDesktopsEventHook <+> fullscreenEventHook
-- myEventHook = ewmhDesktopsEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
-- myLogHook pipe = dynamicLogWithPP  xmobarPP
--                         { ppOutput = hPutStrLn pipe
--                         , ppCurrent = xmobarColor "#AE6F38" "" . wrap "[" "]"
--                         , ppTitle = xmobarColor "#6B8836" "" . shorten 60
--                         }
--                 >> ewmhDesktopsLogHook
--                 >> setWMName "LG3D"
myLogHook pipe = dynamicLogWithPP dzenPP
                        { ppOutput = hPutStrLn pipe
                        , ppCurrent = dzenColor "#AE6F38" "" . wrap "[" "]"
                        , ppTitle = dzenColor "#6B8836" "" . shorten 90
                        }
                >> ewmhDesktopsLogHook

dzenConky = "conky -c ~/.xmonad/conkyrc | /usr/bin/dzen2 -x 800 -w 800 -fn '-misc-fixed-*-*-*-*-12-*-*-*-*-*-*-*' -ta r"

------------------------------------------------------------------------
-- Prompts
--
myXPConfig = defaultXPConfig
    --{
    --    font  = "-*-terminus-*-*-*-*-12-*-*-*-*-*-*-u"
    --    ,fgColor = "#00FFFF"
    --    , bgColor = "#000000"
    --    , bgHLight    = "#000000"
    --    , fgHLight    = "#FF0000"
    --    , position = Top
    --}

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
    --xmproc <- spawnPipe "/usr/bin/xmobar /home/cgirard/.xmobarrc"
    dzproc <- spawnPipe "/usr/bin/dzen2 -w 800 -fn '-misc-fixed-*-*-*-*-12-*-*-*-*-*-*-*' -ta l"
    spawn dzenConky
    xmonad $ docks $ defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = smartBorders (myLayout),
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook dzproc,
        startupHook        = myStartupHook
    }
