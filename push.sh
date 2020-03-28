#!/bin/bash

## script for pushing instantos repos to surge

cd ~/stuff

if [ -e 32bit/build/index.html ]; then
    cd 32bit/build
    surge . instantos32.surge.sh
elif [ -e extra/build/index.html ]; then
    cd extra/build
    surge . instantos.surge.sh
fi
