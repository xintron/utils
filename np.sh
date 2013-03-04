#!/bin/sh
spotify=$(ps -C spotify | wc -l)
tomahawk=$(ps -C tomahawk | wc -l)

if [ $tomahawk -gt 1 ]; then
    playing=$(qdbus org.mpris.MediaPlayer2.tomahawk /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlaybackStatus)
    if [ $playing == 'Playing' ]; then
        data="np: $(qdbus org.mpris.MediaPlayer2.tomahawk /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata | sed -n '/artist/{ N; s/.*: \(.*\)\n.*: \(.*\)$/\1 - \2/p; }')"
        echo $data
    fi
fi
