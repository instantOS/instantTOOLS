#!/bin/bash

# doc: upload files to pacman repo

#####################################################
## script to run after building instantos packages ##
## uploads files to repo                           ##
#####################################################
# clear old database

rm instant.db.*
rm instant.db
rm instant.files.*
rm instant.files

cd ~/instantbuild || exit 1

repo-add instant.db.tar.xz ./*.pkg.tar.*
ls ./*.pkg.tar.zst / &>/dev/null && repo-add instant.db.tar.xz ./*.pkg.tar.zst

date >date.txt

[ -e index.html ] && rm index.html
instantinstall apindex
apindex .

USERNAME="$(imenu cli -i "username")"

[ -z "$USERNAME" ] && exit

# sync to the server
rsync -P -z -a --delete ~/instantbuild/ "$USERNAME"@packages.instantos.io:/var/www/instantos/
