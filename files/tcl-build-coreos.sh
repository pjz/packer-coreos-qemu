#!/bin/bash
HTTPIP=$1
HTTPPort=$2
TARGET=$3
CHANNEL=$4
VERSION=$5

tce-load -wi openssl bash util-linux coreutils gnupg
sudo ln -s /usr/local/bin/gpg2 /usr/local/bin/gpg
wget http://raw.github.com/coreos/init/master/bin/coreos-install
chmod a+x ./coreos-install
wget http://${HTTPIP}:${HTTPPort}/install.yml
sudo ./coreos-install -d ${TARGET} -C ${CHANNEL} -V ${VERSION} -c install.yml
sudo reboot

