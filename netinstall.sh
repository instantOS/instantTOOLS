#!/bin/bash

echo "installing instantOS development tools"

mkdir -p ~/.cache/instanttools
cd ~/.cache/instanttools || exit 1

git clone --depth=1 https://github.com/instantOS/instantTOOLS
cd instantTOOLS || exit 1
chmod +x ./*.sh
./depend.sh
./install.sh
echo "done installing instantOS development tools"
