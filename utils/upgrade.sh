#!/bin/bash

# doc: upgrade instantOS build tools

if ! [ -e /usr/local/share/instanttools/version ]; then
    echo "updating instanttools"
else
    echo "checking for updates"
    NEWID="$(git ls-remote https://github.com/instantOS/instantTOOLS refs/heads/main | grep -Eo '^.{10}')"

    if [ -z "$NEWID" ]; then
        echo "couldn't reach github, please check your internet access"
        exit
    else
        OLDID="$(cat /usr/local/share/instanttools/version)"
        if [ "$OLDID" = "$NEWID" ]; then
            echo "no new update found"
            exit
        fi
    fi
fi

curl -s https://raw.githubusercontent.com/instantOS/instantTOOLS/main/netinstall.sh | bash
