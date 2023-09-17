#!/bin/bash

# doc: build a repo index

cd ~/instantbuild || exit 1

echo "building instant repo db"

# clear old database
# TODO: incrementally add things to db instead of rebuilding each time

rm instant.db.*
rm instant.db
rm instant.files.*
rm instant.files


repo-add instant.db.tar.xz ./*.pkg.tar.*
ls ./*.pkg.tar.zst / &>/dev/null && repo-add instant.db.tar.xz ./*.pkg.tar.zst
date >date.txt

[ -e index.html ] && rm index.html
instantinstall apindex
apindex .

