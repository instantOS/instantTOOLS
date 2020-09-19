#!/bin/bash

# doc: build and install a single instantOS package

if [ -z "$1" ]; then
    if ! [ -e ~/workspace/extra ]
    then
        echo "building cache"
        mkdir -p ~/workspace
        git clone --depth=1 https://github.com/instantOS/extra
    fi

    cd ~/workspace/extra || exit 1
    PACKAGELIST=""
    for i in ./*
    do
        if [ -e "$i"/PKGBUILD ]
        then
            PACKAGENAME="$(grep -o '[^./]*' <<< "$i")"
            PACKAGELIST="$PACKAGELIST
$PACKAGENAME"
        fi
    done
    PACKAGELIST="$(grep '..'<<< "$PACKAGELIST")"
    TARGET="$(fzf <<< "$PACKAGELIST")"
    if [ -z "$TARGET" ] || ! [ -e ~/workspace/extra/"$TARGET"/PKGBUILD ]
    then
        echo "usage: ibuild install packagename"
    else
        ibuild install "$TARGET"
    fi

    exit
fi

pushd .
if ! [ -e ~/workspace/extra ]; then
    mkdir ~/workspace
    cd ~/workspace || exit
    git clone --depth=2 https://github.com/instantOS/extra
    cd extra || exit
else
    cd ~/workspace/extra || exit
    git pull || exit
fi

if ! [ -e "$1" ]; then
    echo "package $1 not found"
    echo "run ibuild install to get a list of available packages"
    exit
fi

cd "$1" || exit
makepkg -si
popd || exit
