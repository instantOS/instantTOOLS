#!/bin/bash

# build and install a single instantOS package

pushd .
if ! [ -e ~/workspace/extra ]; then
    mkdir ~/workspace
    cd ~/workspace
    git clone --depth=2 https://github.com/instantOS/extra
    cd extra
else
    cd ~/workspace/extra
fi

if [ -z "$1" ]; then
    echo "usage: ibuild install packagename"
    exit
fi

if ! [ -e "$1" ]; then
    echo "package $1 not found"
    exit
fi

cd "$1"
makepkg -si
popd
