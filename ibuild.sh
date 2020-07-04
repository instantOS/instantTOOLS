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
updateaur)
    runscript aurupdate "$2"
    ;;
aur)
    source /usr/share/instanttools/utils.sh
    aurinstall "$2" "$3"
    ;;
rebuild)
    if ! imenu -c "this will clear all built packages. Continue"; then
        exit
    fi
    cd
    rm -rf stuff/extra
    rm -rf instantbuild
    mkdir instantbuild
    ibuild fullrepo
    exit
    ;;
*)
    echo "usage: ibuild push/build/download/aur"
    ;;
esac
