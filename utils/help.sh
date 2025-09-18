#!/bin/bash

# doc: display help

echo 'ibuild help'
echo 'usage: ibuild command'
echo 'list of commands'
cd /usr/local/share/instanttools || exit 1

for i in ./*.sh
do
    DESCRIPTION="$(grep '^# doc' "$i" | sed 's/^#[^:]*://g')"
    NAME="$(grep -o '[^./]*\.' <<<"$i" | grep -o '[^.]*')"
    printf '   %-20s %s\n' "$NAME" "$DESCRIPTION"
done
