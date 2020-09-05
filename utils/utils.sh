#!/bin/bash

# doc: some utilities for ibuild

#####################################################
## utilities for building an instantOS repo mirror ##
#####################################################

# ensure PACKAGER is not empty
if ! [ -e ~/.makepkg.conf ]; then
    echo 'PACKAGER="paperbenni <paperbenni@gmail.com>"' >~/.makepkg.conf
else
    if ! grep -iq "PACKAGER" ~/.makepkg.conf; then
        echo 'PACKAGER="paperbenni <paperbenni@gmail.com>"' >>~/.makepkg.conf
    fi
fi

# exit if failed build detected
checkmake() {
    # remove already existing packages
    if ls | grep -q '\.pkg.\.tar\..{1,3}'; then
        rm ./*.pkg.tar.*
    fi

    if makepkg -s . && ls ./*.pkg.tar.xz &>/dev/null; then
        echo "build successful"
    else
        echo "build failed at $(pwd)"
        exit 1
    fi

}

# remove all build files from directory
buildclean() {
    if [ -e pkg ]; then
        rm -rf src
        rm -rf pkg
        rm -rf "$1*"
        rm -rf "*.pkg.tar.xz"
    fi
}

# build a simple bash script package
bashbuild() {
    echo "bashbuilding $1"
    [ -e "$1" ] || return
    cd "$1" || exit

    checkmake

    mv ./*.pkg.tar.xz ~/instantbuild/
    cd ..
}

# build a program from the AUR
aurbuild() {
    if [ -n "$2" ]; then
        AURNAME="$2"
    else
        AURNAME="$1"
    fi

    if ls ~/instantbuild/"$AURNAME"*.pkg.tar.xz; then
        echo "package $AURNAME already exists"
        return
    fi

    rm -rf ~/.cache/tmpaur
    mkdir -p ~/.cache/tmpaur/
    cd ~/.cache/tmpaur/ || exit
    git clone --depth=1 "https://aur.archlinux.org/$1.git" || return 1
    cd "$1" || exit

    sed -i 's/^pkgname=.*/pkgname='"$AURNAME"'/g' PKGBUILD

    # force compatibility
    # disable ninja testing
    sed -i "s/^arch=.*/arch=('any')/g" PKGBUILD
    if uname -m | grep -q '^i'; then
        sed -i "s/.*ninja -C build test.*/echo test/g" PKGBUILD
        sed -i 's/{,\.sig}//g' PKGBUILD
    fi

    checkmake || {
        echo "checkmake failed"
        exit
    }

    mv ~/.cache/tmpaur/"$1"/*.pkg.tar.xz ~/instantbuild/

    cd ..
    rm -rf "$1"
}

aurinstall() {
    if ! curl -s "https://aur.archlinux.org/packages/$1" | grep -iq 'Git clone URL'; then
        echo "$1 is not an aur package"
    fi
    pushd .
    mkdir -p ~/.cache/aur
    cd ~/.cache/aur || exit

    git clone --depth=1 "https://aur.archlinux.org/$1.git" || return 1
    cd "$1" || exit
    if [ -n "$2" ]; then
        sed -i 's/^pkgname=.*/pkgname='"$2"'/g' PKGBUILD
    fi

    # force compatibility
    if uname -m | grep -q '^i'; then
        sed -i "s/^arch=.*/arch=('any')/g" PKGBUILD
    fi

    checkmake
    if ls ./*.pkg.tar.xz; then
        sudo pacman -U ./*.pkg.tar.xz
    fi

    cd ..
    rm -rf "$1"
    popd || exit
}

# download package directly from manjaro-repo
repobuild() {
    if [ -n "$2" ]; then
        MREPO="$1"
        echo "custom repo $MREPO"
        shift 1
        MPACKAGE="$1"
    else
        if echo "$1" | grep -q ':'; then
            MREPO="$(echo "$1" | grep -o '^[^:]*')"
            MPACKAGE="$(echo "$1" | grep -o '[^:]*$')"
        else
            MREPO="extra"
            MPACKAGE="$1"
        fi
    fi

    curl -s https://mirror.alpix.eu/manjaro/stable/"$MREPO"/x86_64/ |
        grep ">$MPACKAGE" | grep -o '>.*<' | grep -o '[^<>]*' | sort | head -1 >/tmp/instantrepo
    echo "dowloading package https://mirror.alpix.eu/manjaro/stable/$MREPO/x86_64/$(cat /tmp/instantrepo)"
    wget "https://mirror.alpix.eu/manjaro/stable/$MREPO/x86_64/$(cat /tmp/instantrepo)"

    ls ./*.pkg.tar.xz &>/dev/null && mv ./*.pkg.tar.xz ~/instantbuild
    ls ./*.pkg.tar.zst &>/dev/null && mv ./*.pkg.tar.zst ~/instantbuild

}

