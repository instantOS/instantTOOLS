#!/bin/bash

# doc: build a full copy of the pacman repo

echo "building instantOS pacman repository"

# exit when a command fails
set -eo pipefail

cd

# build functions
source /usr/local/share/instanttools/utils.sh

# install packages needed to build some AUR stuff
installbuilddeps

if [ -e instantbuild ]; then
    if imenu cli -c 'there are build files already present. Are you sure you want to remove them?'; then
        echo "removing older build files"
        rm -rf instantbuild
    else
        echo 'build cancelled'
    fi
fi

CACHEDIR="$HOME/instantbuildcache/$(date '+%y/%m/%d')"
export CACHEDIR

mkdir -p "$CACHEDIR" || echo 'existing build cache found'
mkdir ~/instantbuild || echo 'existing build directory found'

# detect architecture
UNAME="$(uname -m)"
if grep -q 'x8' <<<"$UNAME"; then
    echo "detected 64 bit build"
elif grep -q '^i' <<<"$UNAME"; then
    echo "detected 32 bit build"
    export ARCH32='32'
else
    echo 'architecture is not supported, support should be easy to add though,
feel free to send a PR to instanttools'
    exit
fi

cd
mkdir stuff || echo "stuff existing" &>/dev/null
cd stuff

echo "removing old pkgbuild repo"
[ -e extra ] && rm -rf extra

git clone --depth=1 https://github.com/instantos/extra.git
cd extra
rm -rf .git

echo "starting instantOS repo build"

BUILDDIR="$(pwd)"

if [ -e aurpackages ]; then
    # aur packages
    for i in $(cat aurpackages); do
        if grep -q ':' <<<"$i"; then
            AURNAME=$(echo $i | grep -o '^[^:]*')
            AURFINALNAME=$(echo $i | grep -o '[^:]*$')
            # buildpackage automatically places files in CACHEDIR
            buildpackage "$AURNAME" "$AURFINALNAME"
        else
            buildpackage "$i"
        fi
        cd "$BUILDDIR"
    done
fi

cd "$BUILDDIR"

# build non-AUR packages
for i in ./*; do
    if [ -e "$i/PKGBUILD" ]; then
        buildpackage "$i"
    else
        echo "skipping folder $i, no PKGFILE found"
    fi
done

cd "$CACHEDIR"
echo "copying built packages to instantbuild directory"
for i in ./*
do
    cp "$i"/*.pkg.tar.zst ~/instantbuild
done

echo "done building packages"

ibuild repoindex || exit 1

