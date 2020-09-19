#!/bin/bash

# doc: add instantOS mirrors

if [ -e /usr/share/instantutils/repo.sh ]
then
    sudo /usr/share/instantutils/repo.sh
else
    curl -s https://raw.githubusercontent.com/instantOS/instantOS/master/repo.sh | sudo bash
fi
