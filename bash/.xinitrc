#!/bin/bash
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#Display and Xorg settings
#export LD_PRELOAD=/usr/lib/VBoxOGL.so
xbindkeys&
#xrandr --auto --output LVDS1 --primary --mode 1366x768 --left-of VGA1 --output VGA1 --mode 1280x1024 --rate 75
VBoxClient-all&
compton -b
nitrogen --restore
#trayer --edge top --align right --SetDockType true --SetPartialStrut true  --expand true --width 10 --transparent true --tint 0x191970 --height 10 &
trayer --edge top --align left --SetDockType true --SetPartialStrut true  --expand true --width 100 --widthtype pixel --tint 0xd6d6d6 --height 8 --margin 1820 --transparent true &
conky -c ~/.config/conky/conkyrc_sys -d & conky -c ~/.config/conky/conkyrc_date -d & conky -c ~/.config/conky/conkyrc_time -d
#dispwin -d1 -I ~/.local/share/color/icc/devices/display/Screen\ 1\ 2011-04-17\ max\ native\ min\ native\ 2.2\ MQ-HQ\ 1xCurve+MTX.icc
#redshift-gtk&
xsetroot -cursor_name left_ptr
xset +fp /usr/share/fonts/envypn
xset +fp /usr/share/fonts/artwiz-fonts
xset fp rehash

#urxvt
#urxvtd -q -o -f

#notification
twmnd&

#dropbox
dropbox&
nextcloud&

#gdfs -o big_writes ~/.gdfs.creds ~/gdrivefs &

netmon&
qopenvpn&

alsavolume&

#proxychains4 -q ssh -p443 -f -N -T -L 8123:localhost:8123 cedric@cedricgirard.com
#ssh -f -N -T -L :8123:localhost:8123 htpc &

#OOo window theme
#export SAL_USE_VCLPLUGIN=gen

#Firefox use OpenGL
export MOZ_USE_OMTC=1

#do not grab WM keys with spice
export SPICE_NOGRAB=1
#termite -e bash &
exec xmonad
