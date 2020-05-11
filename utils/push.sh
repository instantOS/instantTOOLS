#!/bin/bash

#####################################################
## script to run after building instantos packages ##
## uploads files to repo                           ##
#####################################################

cd ~/instantbuild || exit 1

repo-add instant.db.tar.xz ./*.pkg.tar.xz
ls *.zst && repo-add instant.db.tar.xz ./*.pkg.tar.zst

[ -e index.html ] && rm index.html

# clear old database
rm instant.db.*
rm instant.files.*

if ! apindex .; then
    echo "error: apindex not found"
    exit 1
fi

echo "uploading to surge"
if uname -m | grep -q "x86_64"; then
    surge . instantos.surge.sh
else
    surge . instantos32.surge.sh
fi
