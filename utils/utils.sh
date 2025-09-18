#!/bin/bash

# doc: some utilities for ibuild

#####################################################
## utilities for building an instantOS repo mirror ##
#####################################################

# ensure PACKAGER is not empty
if ! [ -e ~/.makepkg.conf ] || ! grep -iq "PACKAGER" ~/.makepkg.conf; then
    echo 'please add a PACKAGER section in ~/.makepkg.conf'
    echo 'example:'
    echo 'PACKAGER="paperbenni <paperbenni@gmail.com>"'
    exit
fi

# install repo build dependencies
installbuilddeps() {
    sudo pacman -S --needed --noconfirm \
        wmctrl \
        xdotool \
        go \
        ninja \
        meson \
        check \
        libnotify \
        tk \
        vala \
        gobject-introspection \
        vte3 \
        dbus-glib \
        appstream-glib \
        archlinux-appstream-data \
        libindicator-gtk3 \
        libindicator-gtk2

    if ! [ -e /usr/share/paperbash/import.sh ]; then
        echo "please install paperbash before running this"
        exit 1
    fi

}

# check if directory $1 contains any valid pacman packages
checkpkgs() {
    if [ -e "$1" ]; then
        for i in "$1"/*.pkg.tar.*; do
            if pacman -Up "$i"; then
                return 0
            fi
        done
    fi
    return 1
}

checkaur() {
    git ls-remote --exit-code -h "https://aur.archlinux.org/$1.git" &>/dev/null || return 1
    return 0
}

# buildpackage packagename targetname
# targetname can be different, for example build yay-git as a package named yay
# packagename can either be a folder with a PKGBUILD or an AUR package name
buildpackage() {
    checkpkgs "$CACHEDIR/$1" && echo "valid pacman file for $1 already built" && return

    if {
        [ -n "$ARCH32" ] && [ -e "$1/32ignore" ]
    } || [ -e "$1"/ignore ] || [ -e /tmp/pkgignore ]; then
        echo "ignoring $1 on 32 bit"
        echo "package $1 is ignored"
        rm /tmp/pkgignore
        return
    fi

    if [ -e ./"$1"/PKGBUILD ]; then
        cp -r "$1" "$CACHEDIR/"
    else
        if checkaur "$1"; then
            git clone --depth=1 "https://aur.archlinux.org/$1.git" "$CACHEDIR/$1"
        else
            echo "$1 not found in AUR or instantos pkgbuilds"
            return 1
        fi
    fi

    pushd "$CACHEDIR/$1" || exit 1

    # rename package to $2 if supplied
    if [ -n "$2" ]; then
        sed -i 's/^pkgname=.*/pkgname='"$2"'/g' PKGBUILD
    fi

    # force compatibility
    sed -i "s/^arch=.*/arch=('any')/g" PKGBUILD
    if [ -n "$ARCH32" ]; then
        # disable ninja testing
        sed -i "s/.*ninja -C build test.*/echo test/g" PKGBUILD
        sed -i 's/{,\.sig}//g' PKGBUILD
    fi

    makepkg -s . || return 1
    checkpkgs . || return 1
    popd || exit 1

}

# remove all build files from directory
buildclean() {
    if [ -e pkg ]; then
        rm -rf src
        rm -rf pkg
        rm -rf "$1*"
        rm -rf "*.pkg.tar.*"
    fi
}

# build a program from the AUR
aurbuild() {
    if [ -n "$2" ]; then
        AURNAME="$2"
    else
        AURNAME="$1"
    fi

    if ls ~/instantbuild/"$AURNAME"*.pkg.tar.*; then
        echo "package $AURNAME already exists"
        return
    fi

    rm -rf ~/.cache/tmpaur
    mkdir -p ~/.cache/tmpaur/
    cd ~/.cache/tmpaur/ || exit
    git clone --depth=1 "https://aur.archlinux.org/$1.git" || return 1
    cd "$1" || exit

    sed -i 's/^pkgname=.*/pkgname='"$AURNAME"'/g' PKGBUILD

    checkmake || {
        echo "checkmake failed"
        exit
    }

    mv ~/.cache/tmpaur/"$1"/*.pkg.tar.* ~/instantbuild/

    cd ..
    rm -rf "$1"
}

aurinstall() {
    if ! checkaur "$1"; then
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
    if ls ./*.pkg.tar.*; then
        sudo pacman -U ./*.pkg.tar.*
    fi

    cd ..
    rm -rf "$1"
    popd || exit
}
