#!/bin/bash

# install ibuild dependencies

if ! command -v pacman; then
    echo "warning, not on an Arch based system, some features will not work"
    exit
fi

echo "instanlling instanttools dependencies"

sudo pacman -S --needed --noconfirm \
    git \
    curl \
    wget \
    fzf

