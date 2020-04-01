#!/usr/bin/env python3

# parses a PKGBUILD file and prints a command to install all dependencies to stdout

import re
import os

if not os.path.exists("PKGBUILD"):
    exit()

build = open("PKGBUILD").read().split('\n')
collector = False

packages = []
pacmancmd = ""


def addpackage(pkgname):
    for i in pkgname.split(' '):
        if re.compile(".*'.*'").match(i):
            packages.append(re.compile("'(.*)'").search(i).group(1))


for i in build:
    if collector:
        if ")" in i:
            collector = False
        addpackage(i)
    else:
        if re.compile('^[^a-zA-Z]*depend').match(i) or \
                re.compile("^[^a-z]*makedepend").match(i):
            if not ')' in i:
                collector = True
            addpackage(i)

pacmancmd = "pacman -Sy --needed --noconfirm "

for i in packages:
    pacmancmd += i + " "
print(pacmancmd)
