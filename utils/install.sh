#!/bin/bash

# doc: build and install a single instantOS package

pushd .
if ! [ -e ~/.config/ibuild/extra ]; then
    echo "building cache"
    mkdir -p ~/.config/ibuild/
    cd ~/.config/ibuild || exit 1
    git clone --depth=3 https://github.com/instantOS/extra
fi
cd ~/.config/ibuild/extra || exit 1
if ! git pull; then
    git stash
    pgrep instantwm && {
        notify-send "stashed local changes"
        echo "stashing local changes"
    }

    git pull || exit 1
fi

if [ -z "$1" ]; then
    PACKAGELIST=""
    for i in ./*; do
        if [ -e "$i"/PKGBUILD ]; then
            PACKAGENAME="$(grep -o '[^./]*' <<<"$i")"
            PACKAGELIST="$PACKAGELIST
$PACKAGENAME"
        fi
    done
    PACKAGELIST="$(grep '..' <<<"$PACKAGELIST")"
    TARGET="$(fzf <<<"$PACKAGELIST")"
    if [ -z "$TARGET" ] || ! [ -e ./"$TARGET"/PKGBUILD ]; then
        echo "usage: ibuild install packagename"
    else
        ibuild install "$TARGET"
    fi
    exit
fi

if ! [ -e "$1"/PKGBUILD ]; then
    echo "package $1 not found"
    echo "run 
    ibuild install 
to get a list of available packages"
    exit
fi

cd "$1" || exit
makepkg -si
popd
