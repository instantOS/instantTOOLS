#!/bin/bash

# doc: build and install a single instantOS package

TESTBRANCH="$(git ls-remote https://github.com/instantos/instantarch | grep 'refs/heads' | grep -o 'refs/.*' | sed 's/^refs\/.*\///g' | imenu -l)"
[ -z "$TESTBRANCH" ] && exit 1

curl -s https://raw.githubusercontent.com/instantOS/instantARCH/"$TESTBRANCH"/archinstall.sh >instantarch.sh

chmod +x ./instantarch.sh
sudo ./instantarch.sh test
