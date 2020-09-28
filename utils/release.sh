#!/bin/bash

# doc: release a new stable branch version

echo "releasing new version"
if ! git fetch origin stable
then
    echo "stable branch not existing"
    exit
fi

git checkout stable || exit 1
git merge master || exit 1
git push origin stable || exit 1
git checkout master || exit 1

echo "updated stable branch"
