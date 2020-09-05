#!/bin/bash

###########################
## instantOS build tools ##
###########################

# this script is the main wrapper

if ! [ -e /usr/share/instanttools ]
then
    if [ -e "$PREFIX/share/instanttools" ]
    then
        TOOLS="$PREFIX/share/instanttools"
    else
        echo "ibuild not installed correctly"
        exit
    fi
else
    TOOLS="/usr/share/instanttools"
fi

if [ -z "$1" ]
then
    SCRIPT="$(ls "$TOOLS/" | grep -o '[^/]*$' | grep -o '^[^.]*' | fzf | head -1)"
else
    if [ -e "$TOOLS/$1.sh" ]
    then
        SCRIPT="$1"
    else
        SLIST="$(ls "$TOOLS/" | grep "^$1")"
        if [ -n "$SLIST" ]
        then
            if wc -l <<< "$SLIST" | grep -o '^1$'
            then
                SCRIPT="$(echo "$SLIST" | grep -o '[^/]*$' | grep -o '^[^.]*')"
            else
                SCRIPT="$(ls "$TOOLS/" | grep "^$1" | grep -o '[^/]*$' | grep -o '^[^.]*' | fzf | head -1)"
            fi
        else
            echo "no match found for $1"
            exit
        fi
    fi
    shift 1
fi

[ -z "$SCRIPT" ] && exit
"$TOOLS/$SCRIPT.sh" "$@"

