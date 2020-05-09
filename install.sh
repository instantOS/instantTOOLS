#!/bin/bash

chmod +x *.sh
chmod +x utils/*.sh

sudo cp ibuild.sh /usr/bin/ibuild
sudo chmod 755 /usr/bin/ibuild 

[ -e /usr/share/instanttools ] || sudo mkdir -p /usr/share/instanttools
sudo cp utils/*.sh /usr/share/instanttools/
sudo chmod 755 /usr/share/instanttools/* 