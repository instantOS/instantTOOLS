#!/bin/bash

# doc: build a full copy of the pacman repo

echo "building instantOS repository"
cd || exit

if ! iconf -i builddeps; then
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
        archlinux-appstream-data \
        appstream-glib \
        libindicator-gtk3 \
        libindicator-gtk2 && iconf -i builddeps 1
fi

if [ -e instantbuild ]; then
    echo "removing older build files"
    rm -rf instantbuild
fi

mkdir ~/instantbuild

# detect architecture
UNAME="$(uname -m)"
if grep -q 'x8' <<<"$UNAME"; then
    echo "detected 64 bit build"
elif grep -q '^i' <<<"$UNAME"; then
    echo "detected 32 bit build"
fi

cd || exit
mkdir stuff &>/dev/null
cd stuff || exit

echo "removing old ones"
[ -e extra ] && rm -rf extra

cd ~/stuff || exit
git clone --depth=1 https://github.com/instantos/extra.git
cd ~/stuff/extra || exit
rm -rf .git

echo "starting instantOS repo build"
# build functions
source /usr/local/share/instanttools/utils.sh

if ! pacman -Qi paperbash &>/dev/null; then
    echo "please install paperbash"
    exit
fi

BUILDDIR="$(pwd)"

# packages brought over from manjaro
if [ -e manjaropackages ]; then
    for i in $(cat manjaropackages); do
        repobuild "$i"
    done
fi

if [ -e aurpackages ]; then
    # aur packages#
    for i in $(cat aurpackages); do
        if grep -q ':' <<<"$i"; then
            AURNAME=$(echo $i | grep -o '^[^:]*')
            AURFINALNAME=$(echo $i | grep -o '[^:]*$')
            aurbuild "$AURNAME" "$AURFINALNAME"
        else
            aurbuild "$i"
        fi
        cd "$BUILDDIR" || exit
    done
fi

cd "$BUILDDIR" || exit
for i in ./*; do
    if [ -e "$i/PKGBUILD" ]; then

        if uname -m | grep -q '^i'; then
            if [ -e "$i"/32ignore ]; then
                echo "package $i is 32 ignored"
                rm /tmp/pkgignore
                continue
            fi
        fi

        if [ -e "$i"/ignore ] || [ -e /tmp/pkgignore ]; then
            echo "package $i is ignored"
            rm /tmp/pkgignore
            continue
        fi
        echo "building $i"
        if ! bashbuild ${i#./}; then
            echo "package $i build failed, exiting"
        fi
    else
        echo "skipping folder $i, no PKGFILE found"
    fi
done
