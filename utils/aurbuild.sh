#!/bin/bash

# doc: build a package from the AUR and put it into the local repo

if [ -z "$1" ]; then
    echo "usage: ./aurbuild.sh packagename"
    exit
fi

if ! [ -e ~/workspace/extra ]; then
    echo "downloading extra"
    mkdir ~/workspace
    cd ~/workspace || exit 1
    git clone --depth=1 https://github.com/instantos/extra
fi

source /usr/local/share/instanttools/utils.sh || exit 1

cd ~/workspace/extra || exit 1
git pull || exit

AURLINE="$(grep "^$1" aurpackages)"

if [ -z "$AURLINE" ]; then
    echo "package is not in AUR list"
    exit 1
fi

if [ "$(wc -l <<<"$AURLINE")" -gt 1 ]; then
    echo "unclear package, aurpackages list is probably messed up"
fi

if grep -q ':' <<<"$AURLINE"; then
    echo "building with a different name"
    AURNAME=$(echo $AURLINE | grep -o '^[^:]*')
    AURFINALNAME=$(echo $AURLINE | grep -o '[^:]*$')
    aurbuild "$AURNAME" "$AURFINALNAME"
else
    aurbuild "$AURLINE"
fi

