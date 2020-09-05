#!/bin/bash

echo "releasing new version"
if ! git fetch origin stable
then
    echo "stable branch not existing"
    exit
fi

git checkout stable || exit 1
git merge master || exit 1
git push || exit 1
echo "updated stable branch"