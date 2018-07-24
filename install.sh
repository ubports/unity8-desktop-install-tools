#!/bin/bash

## We should die on any errors!
set -e

## Check if we are on xenial or bionic
source /etc/os-release
if [ $UBUNTU_CODENAME != "xenial" ] && [ $UBUNTU_CODENAME != "bionic" ]; then
    echo "This is only supported on Ubuntu 16.04 and 18.04."
    exit 1
fi

function do_install {
  ## Do apt update
  sudo apt update

  ## Do apt upgrade
  sudo apt upgrade -y --allow-downgrades

  ## Install unity8 desktop session
  sudo apt install -y unity8-desktop-session

  ## Done, let's tell the user
  echo "------ DONE ------"
  echo "You can now logout and select unity8"
}

function setup_repo {
  ## Make sure gnupg is installed
  sudo apt install -y gnupg

  ## Setup ubports repo
  echo "deb http://repo.ubports.com/ $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ubports.list

  ## Add ubports keyring
  wget http://repo.ubports.com/keyring.gpg -O - | sudo apt-key add -
}

function install {
  setup_repo
  do_install
}

case $UBUNTU_CODENAME in
  "xenial")
    install
  ;;
  "bionic")
    install
   ;;
esac
