#!/bin/bash

# back up repo to other git servers in case github goes boom

if [ -z "$1" ]; then
    echo "usage: ibuild backup projectname"
    exit
fi

if ! git ls-remote https://instantosbackup@bitbucket.org/instantosbackup/"$1".git &>/dev/null; then
    echo "error: bitbucket repo not found"
    exit 1
else
    echo "bitbucket project found"
fi

if ! [ -e ~/workspace/"$1" ]; then
    echo "local project $1 not found"
    exit 1
fi

cd ~/workspace/"$1"
if ! git remote | grep -q instantosbackup; then
    git remote add instantosbackup "https://instantosbackup@bitbucket.org/instantosbackup/$1.git"
fi

if [ "$2" = -f ]; then
    git push -f instantosbackup --all && echo "force backup finished"
else
    git push instantosbackup --all && echo "backup finished"
fi
