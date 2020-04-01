#!/bin/bash

###########################
## instantOS build tools ##
###########################

# this script is the main wrapper

runscript() {
    if [ -e /usr/share/instanttools/$1.sh ]; then
        IBUILDSCRIPT="$1"
        shift 1
        /usr/share/instanttools/$IBUILDSCRIPT.sh $@
    else
        echo "script $1 not found"
        exit 1
    fi
}

case "$1" in
fullrepo)
    runscript directbuild
    ;;
push)
    runscript push
    ;;
download)
    runscript fetch
    ;;
build)
    runscript singlebuild "$2"
    ;;
depend)
    runscript depend
    ;;
*)
    echo "usage: ibuild push/build/download"
    ;;
esac
