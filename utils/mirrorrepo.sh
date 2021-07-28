#!/bin/bash

# doc: mirror the instantOS pacman repo via ipfs
# WARNING: untested

instantinstall go-ipfs || exit 1

USERNAME="$(whoami)"

if [ "$USERNAME" = root ]; then
    echo 'dont run this as root'
    exit
fi

if ! [ -e ~/.ipfs ]; then
    if pgrep Xorg; then
        ipfs init
    else
        # better not risk getting accused of port scanning
        ipfs init --profile server
    fi
fi

if ! pgrep ipfs && ! systemctl --user list-unit-files | grep ipfs | grep -iq enabled
then
    sudo systemctl enable --now "$USERNAME"@ipfs
fi

ipfs pin add /ipns/k51qzi5uqu5dg87hfo10k7ey7fi7i4li3ouk8jis7mckes75tlerv5h62bwv3v || exit 1

echo 'congratulations, you are now helping host the instantOS packages'
