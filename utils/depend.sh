#!/bin/bash

# install dependencies

for i in ./*; do
    if ! [ -e "$i"/PKGBUILD ]; then
        continue
    fi
    cd "$i"
    pkgparse
    sudo bash pkgdepend.sh
    cd ..
done
