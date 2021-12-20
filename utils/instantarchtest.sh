#!/bin/bash

# doc: test an instantarch branch

BRANCHES="$(git ls-remote https://github.com/instantos/instantarch | grep 'refs/heads' | grep -o 'refs/.*' | sed 's/^refs\/.*\///g')"

if command -v imenu; then
    TESTBRANCH="$(imenu -l <<<"$BRANCHES")"
else
    TESTBRANCH="$(fzf <<<"$BRANCHES")"
fi

[ -z "$TESTBRANCH" ] && exit 1

curl -s https://raw.githubusercontent.com/instantOS/instantARCH/"$TESTBRANCH"/archinstall.sh >instantarch.sh

chmod +x ./instantarch.sh

if [ -z "$1" ]; then
    sudo ./instantarch.sh test "$TESTBRANCH"
else
    echo "using testing repo"
    sudo ./instantarch.sh test "$TESTBRANCH" "$1"
fi
