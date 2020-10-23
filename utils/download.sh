#!/bin/bash

# doc: get a copy of the pacman repo

if [ -e ~/instantbuild/instant.db ]; then
    if ! imenu cli -c "already existing, overwrite?"; then
        exit
    fi
    rm -rf ~/instantbuild/
fi

mkdir ~/instantbuild

instantinstall rsync

USERNAME="$(imenu cli -i 'username')"
[ -z "$USERNAME" ] && exit

rsync -Pza --delete "$USERNAME"@packages.instantos.io:/var/www/instantos/ ~/instantbuild/
echo "finished pulling repo"
