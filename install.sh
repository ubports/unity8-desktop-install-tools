#!/bin/bash

## We should die on any errors!
set -e

## Check if we are on xenial or bionic
source /etc/os-release
if [ $UBUNTU_CODENAME != "xenial" ] && [ $UBUNTU_CODENAME != "bionic" ]; then
    echo "This is only supported on Ubuntu xenial and bionic"
    exit 1
fi

## if no root, Sudo me up!
[ $(id -u) -ne 0 ] && exec sudo $0 $SUDOARGS

function do_install {
  ## Do apt update
  apt update

  ## Do apt upgrade
  apt upgrade -y --allow-downgrades

  echo "If you get an option to select display manager, please select lightdm!"
  read -p "Press enter to continue"

  ## Install unity8 desktop session and lightdm
  apt install -y unity8-desktop-session lightdm

  ## Done, let's tell the user
  echo "------ DONE ------"
  echo "You can now logout and select unity8"
}

function setup_repo {
  ## Setup ubports repo
  echo "deb http://repo.ubports.com/ $UBUNTU_CODENAME main" > /etc/apt/sources.list.d/ubports

  ## Add ubports keyring
  wget http://repo.ubports.com/keyring.gpg -O - | apt-key add -
}

function install {
  setup_repo
  do_install
}


function xenial_install {
  setup_repo

  ## Add temp repo until merged into the main repo
  echo "deb http://repo.ubports.com/ xenial_-_mir26 main" >> /etc/apt/sources.list.d/ubports.list

  ## This will be removed once all packages have been moved to ubports repo
  add-apt-repository ppa:ci-train-ppa-service/stable-phone-overlay -y

  ## Add pin
  cat >/etc/apt/preferences.d/ubports.pref << EOL
  Package: *
  Pin: origin repo.ubports.com
  Pin-Priority: 2000

  Package: *
  Pin: release a=xenial_-_mir26
  Pin-Priority: 5000
EOL

<<<<<<< HEAD
  do_install
}
=======
## Do apt upgrade
apt upgrade -y --allow-downgrades
>>>>>>> 24cf63da1e4416b28ffc30f768364f9fcba1d924


<<<<<<< HEAD
case $UBUNTU_CODENAME in
  "xenial")
    xenial_install
  ;;
  "bionic")
    install
   ;;
esac
=======
apt update && apt upgrade -y --allow-downgrades


## Done, let's tell the user
echo "------ DONE ------"
echo "You can now logout and select unity8"
>>>>>>> 24cf63da1e4416b28ffc30f768364f9fcba1d924
