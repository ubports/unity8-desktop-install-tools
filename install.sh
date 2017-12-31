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

## Setup ubports repo
echo "deb http://repo.ubports.com/ xenial main" > /etc/apt/sources.list.d/ubports.list

## Add temp repo until merged into the main repo
echo "deb http://repo.ubports.com/ xenial_-_mir26 main" >> /etc/apt/sources.list.d/ubports.list

## Add pin 
cat >/etc/apt/preferences.d/ubports.pref <<EOL 
Package: *
Pin: origin repo.ubports.com
Pin-Priority: 2000

Package: *
Pin: release a=xenial_-_mir26
Pin-Priority: 5000
EOL

## Add ubports keyring
wget http://repo.ubports.com/keyring.gpg -O - | apt-key add -

## This will be removed once all packages have been moved to ubports repo
add-apt-repository ppa:ci-train-ppa-service/stable-phone-overlay -y

## Do apt update
apt update

## Do apt upgrade
apt upgrade -y

## Install unity8 desktop sessions
apt install -y unity8-desktop-session-mir unity8-desktop-session

apt update && apt upgrade -y

## Done, let's tell the user
echo "------ DONE ------"
echo "You can now logout and select unity8"
