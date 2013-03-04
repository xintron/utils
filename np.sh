#!/bin/sh
tomahawk=$(ps -C tomahawk | wc -l)

if [ $tomahawk -gt 1 ]; then
    playing=$(dbus-send --type=method_call --print-reply --dest=org.mpris.MediaPlayer2.tomahawk /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"PlaybackStatus" | sed -n '/variant/ s/^.*"\([^"]\+\).*$/\1/p')
    if [ $playing == 'Playing' ]; then
        data="np: $(dbus-send --type=method_call --print-reply --dest=org.mpris.MediaPlayer2.tomahawk /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Metadata" | sed -n '/artist/{ n; n; h; };/title/{ n; H; x; s/^.*"\([^"]\+\)"\n.*"\([^"]\+\)".*$/\1 - \2/p}')"
        echo $data
    fi
fi
