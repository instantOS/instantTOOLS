#!/bin/bash

# doc: choose instantOS repo from list of repos to open in browser

source /usr/share/paperbash/import.sh
pb git

{
    ghrepos instantOS | grep -o '/.*' | sed 's/\.git$//g' | grep -o '[^/]*' >~/.cache/instantos/repos2 &&
        cp ~/.cache/instantos/repos2 ~/.cache/instantos/repos
} &

[ -e ~/.cache/instantos/repos ] || sleep 10
[ -e ~/.cache/instantos/repos ] || exit 1

REPOCHOICE="$(
    imenu -l < ~/.cache/instantos/repos
)"

[ -z "$REPOCHOICE" ] && exit 1
instantutils open browser "https://github.com/instantOS/$REPOCHOICE"
