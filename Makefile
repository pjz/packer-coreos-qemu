
default:
	@echo make what?
	@echo "  local - build the box locally"
	@echo "  cloud - build the box locally and push it to the Vagrant Cloud"
	@echo "          (requires supplying USERNAME and TOKEN)"
	@echo "  clean - remove local build artifacts"

local:
	packer build coreos-qemu-localbuid.json

cloud:
	packer build -var 'cloud_token=$(TOKEN)' -var cloud_username=$(USERNAME) coreos-qemu.json

clean:
	rm -rf builds
