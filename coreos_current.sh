#!/bin/bash

# commands to set the channel
stable() {
	CHANNEL=stable
}
alpha() {
	CHANNEL=alpha
}
beta() {
	CHANNEL=beta
}

# commands to show some data about the channel
version() {
	wget -q -O - "${BASEURL}/version.txt" | grep COREOS_VERSION= | cut -d= -f2
}
digest() {
	wget -q -O - "${BASEURL}/coreos_production_iso_image.iso.DIGESTS.asc" |grep coreos_production_iso_image.iso | head -n 1| cut -d' ' -f 1
}

# default to stable channel
stable

# run all the args
while (( "$#" )); do
        BASEURL=https://${CHANNEL}.release.core-os.net/amd64-usr/current
	$1
	shift
done
