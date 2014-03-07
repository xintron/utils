#!/bin/sh
tomahawk=$(ps -C tomahawk | wc -l)
spotify=$(ps -C spotify | wc -l)
mopidy=$(ps -C mopidy | wc -l)

if [ $tomahawk -gt 1 ]; then
    playing=$(dbus-send --reply-timeout=500 --type=method_call --print-reply --dest=org.mpris.MediaPlayer2.tomahawk /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"PlaybackStatus" | sed -n '/variant/ s/^.*"\([^"]\+\).*$/\1/p')
    if [ $playing == 'Playing' ]; then
        data="np: $(dbus-send --reply-timeout=500 --type=method_call --print-reply --dest=org.mpris.MediaPlayer2.tomahawk /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Metadata" | sed -n '/artist/{ n; n; h; };/title/{ n; H; x; s/^.*"\([^"]\+\)"\n.*"\([^"]\+\)".*$/\1 - \2/p}')"
        if [ $# -gt 0 ] && [ $1 = 'space' ]; then
            echo " $data "
        else
            echo $data
        fi
    fi
fi

if [ $spotify -gt 1 ]; then
    playing=$(dbus-send --reply-timeout=500 --type=method_call --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"PlaybackStatus" | sed -n '/variant/s/^.*"\([^"]\+\).*$/\1/p')
    if [ $playing == 'Playing' ]; then
        data="np: $(dbus-send --reply-timeout=500 --type=method_call --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Metadata" | sed -n '/artist/ { n;n; h}; /title/ { n; H; g; s/^.*"\([^"]\+\).*\n.*"\([^"]\+\).*$/\1 - \2/p };')"
        if [ $# -gt 0 ] && [ $1 = 'space' ]; then
            echo " $data "
        else
            echo $data
        fi
    fi
fi

if [ $mopidy -gt 1 ]; then
    data=$(mpc -f "%artist% - %title% [#[%album%#]]")
    if [ -n "$(echo $data | grep 'playing')" ]; then
        echo "np: $data" | head -n1
    fi
fi
