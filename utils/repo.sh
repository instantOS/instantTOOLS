#!/bin/bash

# doc: add instantOS mirrors

if [ -e /usr/local/share/instantutils/repo.sh ]; then
    sudo /usr/local/share/instantutils/repo.sh
else
    curl -s https://raw.githubusercontent.com/instantOS/instantOS/main/repo.sh | sudo bash
fi
