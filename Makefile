
CHANNEL ?= stable

default:
	@echo make what?
	@echo "  local - build the box locally"
	@echo "  cloud - build the box locally and push it to the Vagrant Cloud"
	@echo "          (requires supplying USERNAME and TOKEN)"
	@echo "  clean - remove local build artifacts"


scripts/coreos-install:
	wget -q https://raw.github.com/coreos/init/master/bin/coreos-install -O $@ 
	chmod a+x $@

local:
	packer build coreos-qemu-localbuid.json

CLOUD_ARGS = -var 'cloud_token=$(TOKEN)' -var 'cloud_username=$(USERNAME)'

cloud:
	packer build $(CLOUD_ARGS) coreos-qemu.json

CCUR = ./coreos_current.sh $(CHANNEL)

CURRENT_ARGS = -var 'coreos_channel=$(CHANNEL)' 
CURRENT_ARGS += -var "coreos_version=`$(CCUR) version`" 
CURRENT_ARGS += -var "iso_checksum=`$(CCUR) digest`"

current_cloud:
	packer build $(CLOUD_ARGS) $(CURRENT_ARGS) coreos-qemu.json

clean:
	rm -rf builds
