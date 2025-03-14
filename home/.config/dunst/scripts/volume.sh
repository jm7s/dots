#!/bin/bash

# Ways to call:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
    DIR=`dirname "$0"`
    volume=`get_volume`
if [ "$volume" = "0" ]; then
        icon_name="/home/james/.icons/Tela-grey-dark/16/panel/audio-volume-muted.svg"
dunstify "$volume""      " -i "$icon_name" -t 2000 -h string:synchronous:"─" --replace=555
    else
	if [  "$volume" -lt "10" ]; then
	     icon_name="/home/james/.icons/Tela-grey-dark/16/panel/audio-volume-low.svg"
dunstify "$volume""     " -i "$icon_name" --replace=555 -t 2000
    else
        if [ "$volume" -lt "30" ]; then
            icon_name="/home/james/.icons/Tela-grey-dark/16/panel/audio-volume-low.svg"
        else
            if [ "$volume" -lt "70" ]; then
                icon_name="/home/james/.icons/Tela-grey-dark/16/panel/audio-volume-medium.svg"
            else
                icon_name="/home/james/.icons/Tela-grey-dark/16/panel/audio-volume-high.svg"
            fi
        fi
    fi
fi
bar=$(seq -s "•" $(($volume/5)) | sed 's/[0-9]//g')
dunstify "$volume""     ""$bar" -i "$icon_name" -t 2000 -h string:synchronous:"$bar" --replace=555

}

case $1 in
    up)
	amixer set Master on > /dev/null
	amixer sset Master 5%+ > /dev/null
	send_notification
	;;
    down)
	amixer set Master on > /dev/null
	amixer sset Master 5%- > /dev/null
	send_notification
	;;
    mute)
	amixer set Master 1+ toggle > /dev/null
	if is_mute ; then
    DIR=`dirname "$0"`
    dunstify -i "/home/james/.icons/Tela-grey-dark/16/panel/audio-volume-muted.svg" --replace=555 -u normal "Muted" -t 2000
	else
	    send_notification
	fi
	;;
esac
