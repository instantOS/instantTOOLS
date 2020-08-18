#!/bin/bash
echo "building instantOS repository"
cd || exit

if [ -e instantbuild ]; then
    echo "removing older build files"
    rm -rf instantbuild
    mkdir ~/instantbuild
fi
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
/usr/share/instanttools/build.sh
