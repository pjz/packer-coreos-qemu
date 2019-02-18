
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
HEADLESS ?= true

PACKER_ARGS = -var 'cloud_token=$(TOKEN)' -var 'cloud_username=$(USERNAME)'
PACKER_ARGS += -var 'install_headless=$(HEADLESS)'

CCUR = ./coreos_current.sh $(CHANNEL)
PACKER_ARGS += -var 'coreos_channel=$(CHANNEL)'
PACKER_ARGS += -var "coreos_version=`$(CCUR) version`" 

.PHONY: cloud
cloud:
	packer build $(PACKER_ARGS) coreos-qemu.json

/tmp/coreos-qemu-local.json: coreos-qemu.json
	# use some python to nuke the 'vagrant-cloud' and 'push' sections
	cat coreos-qemu.json | \
	python -c 'import sys,json; j=json.load(sys.stdin); del j["push"];  pp="post-processors"; j[pp][0]=list(i for i in j[pp][0] if i["type"] != "vagrant-cloud") ; print(json.dumps(j, indent=2))' | \
	cat > $@

.PHONY: local
local: /tmp/coreos-qemu-local.json
	packer build $(PACKER_ARGS) -except=vagrant-cloud,push $<

.PHONY: clean veryclean
clean:
	rm -rf builds

veryclean: clean
	rm -rf output packer_cache
