#!/bin/bash

# doc: upload new version of instantOS package to AUR
# currently unmaintained

if [ -z "$1" ]; then
    echo "usage: ibuild updateaur aur package name"
fi

[ -e ~/aur ] || mkdir ~/aur
cd ~/aur || exit

echo "updating extra pkgbuilds"
if ! [ -e extra ]; then
    git clone --depth=1 https://github.com/instantOS/extra
fi

pushd extra || exit
git clean -n -X -d -f -f
git pull
if ! [ -e "$1"/PKGBUILD ]; then
    echo "package $1 not found"
    exit
fi

popd || exit

if [ -e "$1" ]; then
    echo "removing old version"
    rm -rf "$1"
fi

git clone ssh://aur@aur.archlinux.org/"$1" || exit
cd "$1" || exit

if [ -e PKGBUILD ]; then
    echo "comparing old and new version"
    if cmp --silent ./PKGBUILD ~/aur/extra/"$1"/PKGBUILD; then
        echo "same version of PKGBUILD"
        exit
    fi
fi

cp -r ~/aur/extra/"$1"/* .

makepkg --printsrcinfo | tee .SRCINFO
git add .
git commit -m "sync PKGBUILD version to upstream"
git push
