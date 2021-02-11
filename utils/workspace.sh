#!/bin/bash

# doc: open a workspace project in vim

if ! [ -e ~/workspace ]; then
    echo "workspace not existing"
    exit 1
fi

cd || exit 1
cd workspace  || exit 1

if [ -n "$1" ]; then
    MATCHES="$(ls | grep "$1")"
else
    MATCHES="$(ls)"
fi

if [ -n "$MATCHES" ]; then
    if [ "$(echo "$MATCHES" | wc -l)" -gt 1 ]; then
        SELECTION="$(echo "$MATCHES" | fzf)"
    else
        SELECTION="$MATCHES"
    fi

    if [ -z "$SELECTION" ]; then
        exit
    fi
else
    if [ -n "$1" ]; then
        ibuild clone "$1" &&
            ibuild workspace "$1" && exit
    fi
fi

cd ~/workspace/"$SELECTION" || exit 1
nvim .
