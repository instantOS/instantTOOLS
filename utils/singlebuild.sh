#!/bin/bash

#############################################################
## build a single instantOS package and put it in the repo ##
#############################################################

if [ -z "$1" ]; then
    echo "usage: ./singlebuild.sh packagename"
    exit
fi

if ! [ -e ~/workspace/extra ]; then
    echo "downloading extra"
    mkdir ~/workspace
    cd ~/workspace
    git clone --depth=1 https://github.com/instantos/extra
fi

if uname -m | grep -q '^i'; then
    IS32=True
    if ! [ -e ~/workspace/extra ]; then
        echo "downloading extra"
        cd ~/workspace
        git clone --depth=1 https://github.com/instantos/32bit
    fi
fi

if [ -n "$IS32" ]; then
    cd ~/workspace/32bit
    git pull || exit
    cd ..
fi

cd ~/workspace/extra
git pull || exit
cd ..

if [ -n "$IS32" ] && [ -e "32bit/$1/PKGBUILD" ]; then
    echo "found 32 bit package"
    FOUND32=true
else
    if ! [ -e "extra/$1/PKGBUILD" ]; then
        echo "package $1 not found"
        exit 1

    fi
fi

# get a full copy of the repo working first
if ! [ -e ~/stuff/extra/build ]; then
    ibuild download
fi

if [ -n "$FOUND32" ]; then
    cd ~/workspace/32bit/$1
else
    cd ~/workspace/extra/$1
fi

if [ -e "$1".* ]; then
    echo "removing previous version"
    rm "$1".*
fi

mkdir -p ~/.cache/instantos/pkg
cp ~/workspace/extra/$1/* .
cd ~/.cache/instantos/pkg

makepkg

mv *.pkg.tar.xz ~/stuff/extra/build/"$1".pkg.tar.xz

cd
rm -rf .cache/instantos/pkg
echo "done building $1"
