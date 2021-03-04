#!/bin/bash

# install ibuild dependencies

if ! command -v pacman; then
    echo "warning, not on an Arch based system, some features will not work"
    exit
fi

echo "instanlling instanttools dependencies"

if command -v instantinstall; then
    # do fancy instantOS sh*t if on instantos
    instantinstall git curl wget fzf
else
    sudo pacman -Sy --needed --noconfirm \
        git \
        curl \
        wget \
        fzf
fi
