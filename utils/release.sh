#!/bin/bash

# doc: release a new stable branch version

echo "releasing new version"
if ! git fetch origin stable; then
    echo "stable branch not existing"
    exit
fi

if git diff | grep -q '...'; then
    echo "please commit changes before proceeding"
fi

if ! git branch | grep -q stable; then
    git checkout -b stable || exit 1
else
    git checkout stable || exit 1
fi

git merge main || exit 1
git push origin stable || exit 1
git checkout main || exit 1

echo "updated stable branch"
