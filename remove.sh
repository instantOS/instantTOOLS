#!/bin/bash

# uninstall instantOS dev tools and remove leftover files

echo "removing instantOS dev tools"

if command -v termux-info
then
    echo "installing on termux"
    TARGET="$PREFIX"
    sudo(){
        eval "$@"
    }
else
    TARGET="/usr/local"
fi

sudo rm -rf "$TARGET"/share/instanttools

if grep -qi 'instantOS' "$TARGET"/bin/i
then
    sudo rm "$TARGET"/bin/i
fi

sudo rm "$TARGET"/bin/ibuild

if [ -e ~/.cache/instanttools ]
then
    rm -rf ~/.cache/instanttools
fi

echo "finished uninstalling instantOS dev tools"
