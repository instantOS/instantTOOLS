#!/bin/bash

# clears build cache

echo "clearing build cache"
rm -rf ~/.cache/yay
rm -rf ~/workspace/extra
sudo pacman -Scc
