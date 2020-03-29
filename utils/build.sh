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

mkdir build

for i in ./*; do
    if [ -e "$i/PKGBUILD" ]; then

        # dont build unaltered one if there is a 32 bit version
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
        bashbuild ${i#./}
    fi
done

# aur packages
if [ -e aurpackages ]; then
    echo "building aur packages"
    for i in $(cat aurpackages); do
        if grep -q ':' <<<"$i"; then
            AURNAME=$(echo $i | grep -o '^[^:]*')
            AURFINALNAME=$(echo $i | grep -o '[^:]*$')
            aurbuild "$AURNAME" "$AURFINALNAME"
        else
            aurbuild "$i"
        fi
    done
fi
