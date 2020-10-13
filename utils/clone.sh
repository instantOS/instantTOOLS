#!/bin/bash

# doc: clone github stuff

if [ "$1" -eq "$1" ] &>/dev/null; then
    GITARGS="--depth=$1"
    shift 1
fi

if [ -z "$1" ]; then
    GITREPO="$(
        curl -s "https://api.github.com/users/$GHUSER/repos?per_page=100" | grep -E -o 'git@[^"]*' | grep -o ':.*' | grep -E -o '[^:]*' | fzf
    )"
    if [ -z "$REPO" ]; then
        echo "usage: i c repo"
        exit
    fi
else
    if ! grep -q '/' <<<"$1"; then
        export GIT_ASKPASS="ibuild"
        if git ls-remote -h "https://github.com/instantOS/$1"; then
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

echo "cloning git repo $GITREPO"
eval "$(echo git clone "$GITARGS" "$GITREPO" "$GITDEST" | sed 's/  */ /g')" || exit 1
