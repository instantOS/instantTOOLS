#!/bin/bash

# doc: build and install a single instantOS package

curl -Ls git.io/instantarch > instantarch.sh
chmod +x ./instantarch.sh
sudo ./instantarch.sh test
