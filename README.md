# packer-coreos-qemu
Packer template to build a CoreOS Vagrant box for use with the libvirt provider.

Thanks to [bfraser/packer-coreos-qemu](https://github.com/bfraser/packer-coreos-qemu) which was used as a starting point and source of inspiration.

####Table of Contents

1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Building](#building)
4. [Troubleshooting](#troubleshooting)
5. [Vagrantfile](#vagrantfile)

##Overview

CoreOS provides Vagrant boxes for each release, in formats compatible with the [VirtualBox](http://stable.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json) and [VMware Fusion](http://stable.release.core-os.net/amd64-usr/current/coreos_production_vagrant_vmware_fusion.json) providers. However, they do not (at the time of this writing) provide a Vagrant box for use with the libvirt provider. This repository provides a Packer template that can build such a box, and in fact is what's used to create [pjz/coreos-stable](https://app.vagrantup.com/pjz/boxes/coreos-stable).

If you'd like to skip box creation altogether and get right to launching VMs with Vagrant, simply run the following:

```vagrant init pjz/coreos-stable; vagrant up --provider libvirt```

##Requirements

For box creation:

1. [Packer](https://www.packer.io/downloads.html)

For launching VMs using the box:

1. [Vagrant](http://www.vagrantup.com/downloads.html)
2. [libvirt](http://libvirt.org/)
3. [vagrant-libvirt](https://github.com/pradels/vagrant-libvirt)

Also see [Vagrantfile](#vagrantfile) for details of overriding the Vagrant configuration.

##Building

To build a Vagrant box using the default CoreOS channel and version, run the following, substituting your [Vagrant Cloud](https://app.vagrantup.com/) token and username:

```make cloud_cloud USERNAME=myusername TOKEN=mytoken CHANNEL=stable```

If you would like to build a box for a different channel, substitute those variables with the desired values as well. For example:

```make cloud USERNAME=myusername TOKEN=mytoken CHANNEL=alpha```

If you do not wish to push the artifact to cloud, use the `coreos-qemu-localbuild.json` file instead.

By default, the Packer [QEMU builder](https://www.packer.io/docs/builders/qemu.html) uses "virtio" as the disk interface, which results in a target device of ```/dev/vda```. If for some reason you need to install CoreOS to a different device, it can be overriden using the ```install_target``` variable.

### Output
Boxes, once created, show up in the `output/` directory.

### Makefile.local

Makefile.local, if it exists, is included by the main Makefile. 
If you're doing several builds, it's handy to do:
```
echo "USERNAME=myusername" >Makefile.local
echo "TOKEN=mytoken" >>Makefile.local
```

to keep from having to specify those variables on the commandline every time.

##Troubleshooting

If the Packer build is failing and the reason why is not obvious, run the build with ```-var 'install_headless=false'```. This will allow you to observe the process using VNC and should give you an indication of what's gone wrong.

##Vagrantfile

The ```Vagrantfile``` present in the root of this repository contains default settings for Vagrant and the libvirt provider, and is added to the Vagrant box during the Packer build. It should not be necessary to use this file in your projects and, in most cases, it should not be necessary to override any of the settings. If all you want to do is get started with a pre-made box, then run the following:

```vagrant init pjz/coreos-stable; vagrant up --provider libvirt```

If you do have a need to customize some of the settings, however, read on.

By default, the Vagrant box assumes you will be using the ```core``` user and has added the Vagrant insecure SSH key to the authorized keys for this user. If for some reason you have a need to SSH into the box as a different user, add a line such as the following to your ```Vagrantfile```:

```config.ssh.username = 'vagrant'```

Due to the way CoreOS works, Vagrant SSH key insertion and the ```/vagrant``` synced folder have been disabled. If you know what you're doing and have a need for these features, you can override them in your ```Vagrantfile```.

The box assumes you will be using the ```kvm``` driver and "default" storage pool for libvirt. If you have a need to override these or other settings, you may add them to your ```Vagrantfile```. Refer to the [documentation](https://github.com/pradels/vagrant-libvirt/blob/master/README.md) for the [vagrant-libvirt](https://github.com/pradels/vagrant-libvirt) plugin for details.

##Method

After multiple methods failed for various reasons (age, qemu networking, etc), this is the easiest solution I've found: boot tinycorelinux from .iso, then download and run coreos-install from 
there, telling it to install onto `/dev/vda`.

