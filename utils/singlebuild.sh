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
    cd ~/workspace || exit 1
    git clone --depth=1 https://github.com/instantos/extra
fi

cd ~/workspace/extra || exit 1
git pull || exit
cd ..

if ! [ -e "extra/$1/PKGBUILD" ]; then
    echo "package $1 not found"
    exit 1

fi

# get a full copy of the repo working first
if ! [ -e ~/instantbuild ]; then
    ibuild download
fi

cd ~/workspace/extra/"$1" || exit 1

if ls "$1".*; then
    echo "removing previous version"
    rm "$1".*
    rm "$1"*.*
fi

mkdir -p ~/.cache/instantos/pkg
cd ~/.cache/instantos/pkg || exit 1
cp -r ~/workspace/extra/"$1"/* . || exit 1

rm -rf src
rm -rf pkg
rm ./*.pkg.tar.*

makepkg -s . || exit 1

if ls ~/instantbuild/"$1"* &>/dev/null; then
    echo "removing instantbuild pkgfiles"
    rm ~/instantbuild/"$1".*
    rm ~/instantbuild/"$1"-*.*
fi

mv ./*.pkg.tar.* ~/instantbuild/ || exit 1

cd || exit 1
rm -rf .cache/instantos/pkg
echo "done building $1"
