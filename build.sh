#!/bin/bash

set -eu

# Use this script with Makefile.
#   Example: USE_DOWNLOAD_ROOTURL=http://127.0.0.1 ./build.sh <tagname> <networkname>

function color() {
    # Usage: color "31;5" "string"
    # Some valid values for color:
    # - 5 blink, 1 strong, 4 underlined
    # - fg: 31 red,  32 green, 33 yellow, 34 blue, 35 purple, 36 cyan, 37 white
    # - bg: 40 black, 41 red, 44 blue, 45 purple
    printf '\033[%sm%s\033[0m\n' "$@"
}

if [ $# -eq 2 ]; then
  version="$1"
  networkname="$2"
else
  color "31" "No args found or args len error, please run with 'make'."
fi

color "" "Current Network is ${networkname}"

version="$1"
color "" "Current version is ${version}"

mkdir -p build/${networkname}
cd build/${networkname}
tar czvf newchain-${networkname}-${version}.tar.gz -C ./../../ ${networkname}
shasum -a 256 newchain-${networkname}-${version}.tar.gz > newchain-${networkname}-${version}.tar.gz.sha256
cp ./../../newchain.sh newchain.sh
sed  -i "s/newchain_deploy_latest_version=.*/newchain_deploy_latest_version='${version}'/" newchain.sh
sed  -i "s/default_networkname=.*/default_networkname='${networkname}'/" newchain.sh
if [[ -n ${USE_DOWNLOAD_ROOTURL:-} ]]; then
  sed  -i "s,download_rooturl=.*,download_rooturl='${USE_DOWNLOAD_ROOTURL}'," newchain.sh
fi


