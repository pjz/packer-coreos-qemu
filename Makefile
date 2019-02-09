
-include Makefile.local


default:
	@echo make what?
	@echo "  local - build the box locally"
	@echo "  cloud - build the box locally and push it to the Vagrant Cloud"
	@echo "          (requires supplying USERNAME and TOKEN)"
	@echo "  clean - remove local build artifacts"
	@echo "  veryclean - remove local build artifacts, outputs, and caches"


CHANNEL ?= stable
TOKEN ?= faketoken
USERNAME ?= fakeuser

CLOUD_ARGS = -var 'cloud_token=$(TOKEN)' -var 'cloud_username=$(USERNAME)'

CCUR = ./coreos_current.sh $(CHANNEL)
CURRENT_ARGS = -var 'coreos_channel=$(CHANNEL)' 
CURRENT_ARGS += -var "coreos_version=`$(CCUR) version`" 

.PHONY: cloud
cloud:
	packer build $(CLOUD_ARGS) $(CURRENT_ARGS) coreos-qemu.json

.PHONY: local
local:
	packer build $(CLOUD_ARGS) $(CURRENT_ARGS) -except=vagrant-cloud,push coreos-qemu.json

.PHONY: clean veryclean
clean:
	rm -rf builds

veryclean: clean
	rm -rf output packer_cache
