#!/bin/bash

echo "installing instantOS development tools"

chmod +x ./*.sh
chmod +x utils/*.sh

if command -v termux-info
then
    echo "installing on termux"
    TARGET="$PREFIX"
    sudo(){
        eval "$@"
    }
else
    TARGET="/usr"
fi

sudo cp ibuild.sh $TARGET/bin/ibuild
sudo chmod 755 $TARGET/bin/ibuild

[ -e $TARGET/share/instanttools ] || \
    sudo mkdir -p $TARGET/share/instanttools

sudo cp utils/*.sh $TARGET/share/instanttools/
sudo chmod 755 $TARGET/share/instanttools/*

if command -v termux-info
then
    ln -s "$TARGET/bin/ibuild" "$TARGET/bin/i" 
fi

echo "finished installing instantOS development tools"
