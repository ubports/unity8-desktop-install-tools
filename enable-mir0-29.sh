#!/bin/bash

## We should die on any errors!
set -e

## Check if we are on xenial
source /etc/os-release
if [ $UBUNTU_CODENAME != "xenial" ]; then
    echo "This is only supported on xenial"
    exit 1
fi

## if no root, Sudo me up!
[ $(id -u) -ne 0 ] && exec sudo $0 $SUDOARGS

echo "deb http://repo.ubports.com/ xenial main" > /etc/apt/sources.list.d/ubports.list
echo "deb http://repo.ubports.com/ xenial_-_mir26 main" >> /etc/apt/sources.list.d/ubports.list

echo "deb http://repo.ubports.com/ xenial_-_mir29 main" >> /etc/apt/sources.list.d/ubports.list
apt update

echo "I will do a dist upgrade!"
apt dist-upgrade

apt autoremove -y
echo "--- DONE ---"
