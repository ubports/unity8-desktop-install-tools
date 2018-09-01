#!/bin/bash

## We should die on any errors!
set -e

## Check if we are on xenial or bionic
source /etc/os-release
if [ $UBUNTU_CODENAME != "xenial" ] && [ $UBUNTU_CODENAME != "bionic" ]; then
    echo "This is only supported on Ubuntu xenial and bionic"
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
  sudo apt install gnupg

  ## Setup ubports repo
  echo "deb http://repo.ubports.com/ $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ubports.list

  ## Add ubports keyring
  wget http://repo.ubports.com/keyring.gpg -O - | sudo apt-key add -
}

function install {
  setup_repo
  do_install
}

function need_lightdm {
  echo "If you get an option to select display manager, please select lightdm!"
  read -p "Press enter to continue"
  sudo apt install -y lightdm
}

function xenial_install {
  setup_repo

  ## Add temp repo until merged into the main repo
  echo "deb http://repo.ubports.com/ xenial_-_mir26 main" | sudo tee -a /etc/apt/sources.list.d/ubports.list

  ## Add pin
  sudo tee /etc/apt/preferences.d/ubports.pref << EOL
  Package: *
  Pin: origin repo.ubports.com
  Pin-Priority: 2000

  Package: *
  Pin: release a=xenial_-_mir26
  Pin-Priority: 5000
EOL

  do_install
  need_lightdm
}


case $UBUNTU_CODENAME in
  "xenial")
    xenial_install
  ;;
  "bionic")
    install
   ;;
esac
