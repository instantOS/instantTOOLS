#!/bin/bash

# doc: upload files to pacman repo

#####################################################
## script to run after building instantos packages ##
## uploads files to repo                           ##
#####################################################

set -eo pipefail

cd ~/instantbuild || exit 1

ibuild repoindex || exit 1

USERNAME="$(imenu cli -i "username")"
[ -z "$USERNAME" ] && exit

# sync to the server
if [ -z "$1" ]; then
    rsync -P -z -a --delete ~/instantbuild/ "$USERNAME"@packages.instantos.io:/var/www/html/
else
    rsync -P -z -a --delete ~/instantbuild/ "$USERNAME"@packages.instantos.io:/var/www/html/"$1"
fi

