#!/bin/bash

# doc: clone github stuff

if [ "$1" -eq "$1" ] &>/dev/null; then
    GITARGS="--depth=$1"
    shift 1
fi

if [ -z "$1" ]; then
    REPO="$(
        curl -s "https://api.github.com/users/instantos/repos?per_page=100" | grep -E -o 'git@[^"]*' | sed 's/^.*\///;s/\.git$//' | fzf
    )"
    if [ -z "$REPO" ]; then
        echo "usage: i c repo"
        exit
    fi
    GITREPO="https://github.com/instantOS/$REPO"
else
    if ! grep -q '/' <<<"$1"; then
        export GIT_ASKPASS="ibuild"
        if git ls-remote -h "https://github.com/instantOS/$1" &> /dev/null; then
            GITREPO="https://github.com/instantOS/$1"
        else
            GITREPO="https://github.com/instantOS/instant$1"
        fi
    elif ! grep -q '//' <<<"$1"; then
        GITREPO="https://github.com/$1"
    else
        GITREPO="$1"
    fi

    if [ -n "$2" ]; then
        GITDEST="$2"
    fi
fi

if [ -e ~/.ssh/id_rsa.pub ]; then
    if [ "$(sha256sum ~/.ssh/id_rsa.pub | grep -o '^[^ ]*')" = "cd60a9c6e385bd05785969f375177daef8d75530350b25555c43d54a1f9b0169" ]; then
        echo switching git to ssh
        GITREPO="$(
            echo "$GITREPO" | sed 's~^https://~git@~g' | sed "s~github.com/~github.com:~g"
        )"
    fi
fi

echo "cloning git repo $GITREPO"

eval "$(echo git clone "$GITARGS" "$GITREPO" "$GITDEST" | sed 's/  */ /g')" || exit 1
