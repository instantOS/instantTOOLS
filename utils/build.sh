#!/bin/bash
#################################################
## build all instantos packages in a directory ##
#################################################

echo "starting instantOS repo build"
# build functions
source /usr/share/instanttools/utils.sh

if ! pacman -Qi paperbash &>/dev/null; then
    echo "please install paperbash"
    exit
fi

BUILDDIR="$(pwd)"
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
        cd "$BUILDDIR"
    done
fi

# packages brought over from manjaro
if [ -e manjaropackages ]; then
    for i in $(cat aurpackages); do
        repobuild "$i"
    done
fi

cd "$BUILDDIR"
for i in ./*; do
    if [ -e "$i/PKGBUILD" ]; then
        # 32 bit versions override default ones
        if pwd | grep -q 'extra'; then
            if [ -e ~/stuff/32bit/"$i" ]; then
                touch /tmp/pkgignore
                echo "ignoring package because its also in 32bit repo"
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
