#!/usr/bin/env python3

# parses a PKGBUILD file and prints a command to install all dependencies to stdout

import re
import os

if not os.path.exists("PKGBUILD"):
    exit()

build = open("PKGBUILD").read().split('\n')
collector = False

if os.path.exists(os.environ["HOME"] + "/stuff/extra"):
    aurpackages = open(os.environ["HOME"] + "/stuff/extra/aurpackages").read()

if os.path.exists(os.environ["HOME"] + "/stuff/32bit"):
    thirtytwo = open(os.environ["HOME"] + "/stuff/32bit/aurpackages").read()

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
    if os.system("pacman -Ss " + i) == 0:
        os.system("pacman -S --needed --noconfirm " + i)
    elif os.system("curl -s https://aur.archlinux.org/packages/" + i + " | grep -q 'Git Clone URL'") == 0:
        os.system("ibuild aur " + i)

script = open("pkgdepend.sh", "w")
script.write(pacmancmd)

print(pacmancmd)
