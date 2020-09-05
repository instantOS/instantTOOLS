#!/bin/bash

# doc: clone github stuff

if [ -z "$1" ]
then
    echo "usage: i c repo"
    exit
fi


if [ "$1" -eq "$1" ] && [ -n "$2" ]
then
    GITARGS="--depth=$1"
    shift 1
fi

if ! grep -q '/' <<< "$1"
then
   GITREPO="https://github.com/instantOS/$1" 
elif ! grep -q '//' <<< "$1"
then
   GITREPO="https://github.com/$1" 
else
   GITREPO="$1" 
fi

if [ -n "$2" ]
then
    GITDEST="$2"
fi

git clone "$GITARGS" "$GITREPO" "$GITDEST"

