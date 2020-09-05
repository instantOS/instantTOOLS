#!/bin/bash

# doc: get a copy of the pacman repo

mkdir ~/instantbuild

echo "pulling full repo"

if ! uname -m | grep -q '^i'; then
    LINK="instantos.surge.sh"
else
    mkdir -p ~/instantbuild
    echo "fetching 32 bit repo"
    LINK="instantos32.surge.sh"
fi

curl -s "$LINK" | grep -o '<a href=".*">' | grep -o '".*"' | grep -Eo '[^"]{3,}' >files.txt

for i in $(cat files.txt); do
    echo "downloading file $i"
    wget -q http://$LINK/$i
done

wget -r http://$LINK

rm files.txt
echo "done"
