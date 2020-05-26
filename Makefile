Version=`git describe --abbrev=0 --tags || git rev-parse --short HEAD || date +%Y%m%d%H%M%S`

all:
	tar czvf newchain-mainnet-${Version}.tar.gz mainnet
	shasum -a 256 newchain-mainnet-${Version}.tar.gz > newchain-mainnet-${Version}.tar.gz.sha256
	sed  -i "s/newchain_deploy_latest_version=.*/newchain_deploy_latest_version='${Version}'/" newchain.sh

