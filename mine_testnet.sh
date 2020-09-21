#!/bin/bash

networkname="testnet"

cd /data/newchain/${networkname}/

function color() {
    # Usage: color "31;5" "string"
    # Some valid values for color:
    # - 5 blink, 1 strong, 4 underlined
    # - fg: 31 red,  32 green, 33 yellow, 34 blue, 35 purple, 36 cyan, 37 white
    # - bg: 40 black, 41 red, 44 blue, 45 purple
    printf '\033[%sm%s\033[0m\n' "$@"
}
color "37" ""

if [[ $(/data/newchain/testnet/bin/geth attach /data/newchain/testnet/nodedata/geth.ipc --exec eth.syncing) != "false" ]]; then
  color "31" "Please wait until your node synchronization is complete"
  exit 0
else
  color "37" "Your node has been synchronized"
fi

# Trying to get current miner address if exits
address=$(/data/newchain/testnet/bin/geth attach /data/newchain/testnet/nodedata/geth.ipc --exec eth.coinbase | sed 's/\"//g')
if [[ ${address} != 0x* || ${#address} < 42 ]]; then
  # Account
  echo -n "Create new password for your miner's keystore: "
  read -s password
  echo
  echo $password > /data/newchain/${networkname}/password.txt

  # /data/newchain/${networkname}/bin/geth --config /data/newchain/${networkname}/conf/node.toml account new --password /data/newchain/${networkname}/password.txt
  address=`/data/newchain/${networkname}/bin/geth --config /data/newchain/${networkname}/conf/node.toml account new --password /data/newchain/${networkname}/password.txt | grep "Public address" | awk '{print $6}'`
  echo "you miner address is: |${address}|"
  if [[ ${address} != 0x* || ${#address} < 42 ]]; then
    color "31" "address len error"
    exit 1
  fi
  color "32" "Your miner address keystore is under /data/newchain/${networkname}/nodedata， please backup it."
fi

current_time=$(date +"%Y%m%d%H%M%S")
cp /data/newchain/${networkname}/conf/node.toml /data/newchain/${networkname}/conf/node.bak.${current_time}.toml
cp /etc/supervisor/conf.d/newchain.conf /data/newchain/${networkname}/supervisor/newchain.bak.${current_time}.conf
sudo sed  -i "s,command=.*,command=/data/newchain/testnet/bin/geth --config /data/newchain/testnet/conf/node.toml --mine --unlock ${address} --password /data/newchain/${networkname}/password.txt --allow-insecure-unlock --miner.gastarget 100000000," /etc/supervisor/conf.d/newchain.conf
sudo supervisorctl update

# get IPs from ifconfig and dig
#LOCALIP=$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | head -n1 | awk '{print $2}' | cut -d':' -f2)
IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

color "37" "Copy the following information and share it with other mining nodes: "
color "32" "
Address: ${address}
IP: ${IP}
"
