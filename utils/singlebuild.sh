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

cd ~/workspace/extra
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


cd ~/workspace/extra/$1

if [ -e "$1".* ]; then
    echo "removing previous version"
    rm "$1".*
    rm "$1"*.*
fi

mkdir -p ~/.cache/instantos/pkg
cd ~/.cache/instantos/pkg
cp -r ~/workspace/extra/$1/* .

rm -rf src
rm -rf pkg
rm *.pkg.tar.*

makepkg . || exit 1

if ls ~/instantbuild/"$1"* &>/dev/null; then
    echo "removing instantbuild pkgfiles"
    rm ~/instantbuild/"$1".*
    rm ~/instantbuild/"$1"-*.*
fi

mv *.pkg.tar.xz ~/instantbuild/ || exit 1

cd
rm -rf .cache/instantos/pkg
echo "done building $1"
