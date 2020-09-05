#!/bin/bash

# install ibuild dependencies

echo "installing dependencies to build instantos packages"
sudo pacman -S --needed \
    wmctrl \
    xdotool \
    go \
    ninja \
    meson \
    check \
    rxvt-unicode \
    libnotify \
    tk \
    vala \
    gobject-introspection \
    vte3 \
    dbus-glib \
    archlinux-appstream-data \
    appstream-glib \
    libindicator-gtk3 \
    libindicator-gtk2
