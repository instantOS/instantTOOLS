#!/bin/bash

# doc: clear and rebuild the pacman repo

if ! imenu -c "this will clear all built packages. Continue"; then
    exit
fi

cd || exit 1
rm -rf stuff/extra
rm -rf instantbuild
mkdir instantbuild
ibuild fullrepo
exit
