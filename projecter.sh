#!/usr/bin/env bash
set -u

verbose=0
this_screen=LDVS
that_screen=HDMI1

# A spellbook for projector interfacing

usage (){
cat << EOF
DESC
    A loose wrapper for xrandr
ARGUMENTS
    -q       print screen status (xrandr -q)
    -a PORT  this screen (use the default, ignore the warning)
    -b PORT  that screen
    -o       open projector
    -x       close projector
    -r XxY   change resolution (e.g. 1280x720)   
    -h       print this help message and exit
EXAMPLE
    ./projector -q   # see what is connected
    ./projector -o   # works for HDMI connections
    ./projector -x   # works for HDMI connections
EOF
    exit 0
}

function print_status() {
    if [[ $verbose -eq 1 ]]
    then
        xrandr --properties
    else
        xrandr
    fi
}

open_port() {
    # Connect this screen to projector
    xrandr --output $this_screen \
           --auto --output $that_screen \
           --auto --same-as $this_screen
    # Mirror this to that
    xrandr --output $this_screen \
           --auto --output $that_screen \
           --auto --right-of $this_screen 
}

close_port() {
    xrandr --output $that_screen --off
}

# print help with no arguments
[[ $# -eq 0 ]] && usage

while getopts "hqoxa:b:r:" opt; do
    case $opt in
        h)
            usage ;;
        q)
            print_status ;;
        a)
            this_screen=$OPTARG ;;
        b)
            that_screen=$OPTARG ;;
        o)
            open_port ;;
        x)
            close_port ;;
        r)
            change_resolution $OPTARG ;;
        v)
            verbose=1 ;;
    esac 
done
