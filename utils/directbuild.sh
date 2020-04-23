#!/bin/bash
echo "building instantOS repository"
cd

if [ -e instantbuild ]; then
    echo "removing older build files"
    rm -rf instantbuild
    mkdir ~/instantbuild
fi
# detect architecture
UNAME="$(uname -m)"
if grep -q 'x8' <<<"$UNAME"; then
    echo "detected 64 bit build"
elif
    grep -q '^i' <<<"$UNAME"
then
    echo "detected 32 bit build"
    BUILD32=true
fi

cd
mkdir stuff &>/dev/null
cd stuff

echo "removing old ones"
[ -e extra ] && rm -rf extra
[ -e 32bit ] && rm -rf 32bit

if [ -n "$BUILD32" ]; then
    echo "building 32bit exclusive packages"
    git clone --depth=1 https://github.com/instantos/32bit.git
    cd 32bit
    /usr/share/instanttools/build.sh || exit 1
fi

cd ~/stuff
git clone --depth=1 https://github.com/instantos/extra.git
cd ~/stuff/extra
/usr/share/instanttools/build.sh
