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
	@echo "${VERSION}: files under './build'."

main:
	echo ${VERSION}
	bash build.sh ${VERSION} "mainnet"
	@echo "Done mainnet building."
	@echo "${VERSION}: run 'cd ./build/mainnet && sudo bash newchain.sh' to install mainnet."

test:
	bash build.sh ${VERSION} "testnet"
	@echo "Done testnet building."
	@echo "${VERSION}: run 'cd ./build/testnet && sudo bash newchain.sh' to install testnet."

clean:
	rm -r build/

check:
	@[ "${VERSION}" ] && echo "VERSION is $(VERSION)" || ( echo "VERSION is not set"; exit 1 )