#!/bin/bash

# build and install a single instantOS package

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

if [ -z "$1" ]; then
    echo "usage: ibuild install packagename"
    exit
fi

if ! [ -e "$1" ]; then
    echo "package $1 not found"
    exit
fi

cd "$1" || exit
makepkg -si
popd || exit
