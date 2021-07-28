#!/bin/bash

# doc: test an instantarch branch

TESTBRANCH="$(git ls-remote https://github.com/instantos/instantarch | grep 'refs/heads' | grep -o 'refs/.*' | sed 's/^refs\/.*\///g' | imenu -l)"
[ -z "$TESTBRANCH" ] && exit 1

curl -s https://raw.githubusercontent.com/instantOS/instantARCH/"$TESTBRANCH"/archinstall.sh >instantarch.sh

chmod +x ./instantarch.sh

if [ -z "$1" ]; then
    sudo ./instantarch.sh test "$TESTBRANCH"
else
    echo "using testing repo"
    sudo ./instantarch.sh test "$TESTBRANCH" "$1"
fi
