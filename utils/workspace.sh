#!/bin/bash

# doc: open a workspace project in vim

if ! [ -e ~/workspace ]
then
    echo "workspace not existing"
    exit 1
fi

cd "workspace"

if [ -n "$1" ]
then
    MATCHES="$(ls | grep "$1")"
else

    MATCHES="$(ls)"
fi

if [ -n "$MATCHES" ]
then
    if [ "$(echo "$MATCHES" | wc -l)" -gt 1 ]
    then
        SELECTION="$(echo "$MATCHES" | fzf)"
    else
        SELECTION="$MATCHES"
    fi

    if [ -z "$SELECTION" ]
    then
        exit
    fi
else
    if [ -n "$1" ]
    then
        ibuild clone "$1"
    fi
fi

cd ~/workspace/"$SELECTION"
nvim .
