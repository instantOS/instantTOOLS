#!/bin/bash

# clone instantOS dev tools and install them

echo "installing instantOS development tools"

[ -e ~/.cache/instanttools ] && rm -rf ~/.cache/instanttools
mkdir -p ~/.cache/instanttools
cd ~/.cache/instanttools || exit 1

command -v git &> /dev/null || {
    pacman -Sy git --noconfirm
}

git clone --depth=1 https://github.com/instantOS/instantTOOLS
cd instantTOOLS || exit 1
chmod +x ./*.sh
./depend.sh
./install.sh
echo "done installing instantOS development tools"
sleep 2
