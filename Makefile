gittagname := $(shell git describe --abbrev=0 --tags)
gitcommit := $(shell  git rev-parse --short HEAD)
versiondate := $(shell date +%Y%m%d%H%M%S)

ifeq  ($(gittagname),)
else
VERSION := $(if $(VERSION),$(VERSION),$(gittagname))
endif
ifeq ($(gitcommit),)
else
VERSION := $(if $(VERSION),$(VERSION)-$(gitcommit),$(gitcommit))
endif
ifeq ($(versiondate),)
else
VERSION := $(if $(VERSION),$(VERSION),$(versiondate))
endif


all:	main test
	@echo "${VERSION}: copy files under './build' to release server."

main:
	echo ${VERSION}
	bash build.sh ${VERSION} "mainnet"
	@echo "Done mainnet building."
	@echo "${VERSION}: copy files under './build/mainnet' to mainnet release server."

test:
	bash build.sh ${VERSION} "testnet"
	@echo "Done testnet building."
	@echo "${VERSION}: copy files under './build/testnet' to testnet release server."

clean:
	rm -r build/

check:
	@[ "${VERSION}" ] && echo "VERSION is $(VERSION)" || ( echo "VERSION is not set"; exit 1 )