#!/bin/bash

echo "installing instantOS development tools"

chmod +x ./*.sh
chmod +x utils/*.sh

if command -v termux-info; then
    echo "installing on termux"
    TARGET="$PREFIX"
    sudo() {
        eval "$@"
    }
else
    TARGET="/usr/local"
fi

echo "installing to $TARGET"
sudo cp ibuild.sh $TARGET/bin/ibuild
sudo chmod 755 $TARGET/bin/ibuild

[ -e $TARGET/share/instanttools ] ||
    sudo mkdir -p $TARGET/share/instanttools

sudo cp utils/*.sh $TARGET/share/instanttools/

sudo chmod 755 $TARGET/share/instanttools/*

echo 'generating help cache'
rg '^# doc:.*' $TARGET/share/instanttools/* | sed 's/:# doc: /\n    /g' | sed 's/^\/.*\///g' | sed 's/.sh$//g' | sudo tee $TARGET/share/instanttools/helpcache.txt
echo 'finished generating help cache
'

if ! command -v i; then
    sudo ln -s "$TARGET/bin/ibuild" "$TARGET/bin/i"
fi

git log --format="%H" -n 1 | grep -Eo '^.{10}' | sudo tee /usr/local/share/instanttools/version
echo "finished installing instantOS development tools"
