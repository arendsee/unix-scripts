#!/bin/bash

# all this must be done in ROOT

set -u

realMAC=
fakeMAC=

get-current-mac () {
    ip link show wlan0 |
    sed -rn 's,.*link/ether ([^ ]+).*,\1,p'
}

setMAC (){
    mac=$1
    currentMAC=`get-current-mac`
    ip link set dev wlan0 down
    ip link set dev wlan0 address $mac && echo "$currentMAC -> $mac"
    ip link set dev wlan0 up
}

usage (){
cat<<EOF
Connect to the damn internet
  -j       Connect to WPA
  -u       Revert to hardware MAC
  -s SSID  Connect to passwordless network
  -x       Revert to real MAC and close connection
  -r       Refresh connection
  -m       Get MAC
EOF
    exit 0
}

# print help with no arguments
[[ $# -eq 0 ]] && usage

while getopts "hjurms:x" opt; do
    case $opt in
        h)
            usage
            ;;
        s) 
            [[ -z $fakeMac ]] || setMAC $fakeMAC
            iw dev wlan0 connect $OPTARG
            dhcpcd wlan0
            ;;
        m)
            get-current-mac
            ;;
        j)
            # must be run with su
            [[ -z $realMac ]] || setMAC $realMAC
            wpa_supplicant      \
                -B              \
                -D nl80211,wext \
                -i wlan0        \
                -c <(wpa_passphrase 'SSID' 'PASSWORD')
            dhcpcd wlan0
            ;;
        u)
            [[ -z $realMac ]] || setMAC $realMAC
            ;;
        x)
            [[ -z $realMac ]] || setMAC $realMAC
            ip link set dev wlan0 down
            dhcpcd -x wlan0
            ;;
        r)
            ip link set dev wlan0 down
            sleep 1s
            dhcpcd -x wlan0
            sleep 1s
            ip link set dev wlan0 up
            ;;
    esac 
done
