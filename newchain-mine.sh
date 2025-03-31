#!/bin/bash

default_networkname="mainnet"

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

if [[ "$*" == "" ]]; then
  networkname="${default_networkname}"
elif [[ "$*" == "mainnet" || "$*" == "main" ]]; then
  networkname="mainnet"
elif [[ "$*" == "testnet" || "$*" == "test" ]]; then
  networkname="testnet"
else
  color "31" "Not support network $*."
  exit 1
fi
color "32" "Current NewChain network is ${networkname}"

if [[ $(/data/newchain/${networkname}/bin/geth attach /data/newchain/${networkname}/nodedata/geth.ipc --exec eth.syncing) != "false" ]]; then
  color "31" "Please wait until your node synchronization is complete"
  exit 0
else
  color "37" "Your node has been synchronized"
fi

# Trying to get current miner address if exits
address=$(/data/newchain/${networkname}/bin/geth attach /data/newchain/${networkname}/nodedata/geth.ipc --exec eth.coinbase | sed 's/\"//g')
if [[ ${address} != 0x* || ${#address} < 42 ]]; then
  # Account
  color "" "Create new password for your miner's keystore."
  color "" "Your new account is locked with a password. Please give a password. Do not forget this password."
  echo -n "Password: "
  read -s password0
  echo
  echo -n "Repeat password: "
  read -s password1
  echo
  if [[ ${password0}  != ${password1} ]]; then
    color "31" "Passwords do not match"
    exit 0
  fi
  if [[ ${password0} == "" ]]; then
    color "31" "Passwords is empty"
    exit 0
  fi
  if ( echo ${password0} | grep -q ' ' ); then
    color "31" "Passwords has space"
    exit 0
  fi
  echo ${password0} > /data/newchain/${networkname}/password.txt

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
# node.toml: disable rpc
cp /data/newchain/${networkname}/conf/node.toml /data/newchain/${networkname}/conf/node.bak.${current_time}.toml
sudo sed  -i "s,HTTPHost.*,HTTPHost = \"\"," /data/newchain/${networkname}/conf/node.toml

# Supervisor: update command to enable mine
cp /etc/supervisor/conf.d/newchain.conf /data/newchain/${networkname}/supervisor/newchain.bak.${current_time}.conf
sudo sed  -i "s,command=.*,command=/data/newchain/${networkname}/bin/geth --config /data/newchain/${networkname}/conf/node.toml --mine --unlock ${address} --password /data/newchain/${networkname}/password.txt --miner.gastarget 100000000," /etc/supervisor/conf.d/newchain.conf

# Guard: disable newchain guard
sudo mv /etc/supervisor/conf.d/newchainguard.conf /data/newchain/${networkname}/supervisor/newchainguard.bak.${current_time}.conf

sudo supervisorctl update

# get IPs from ifconfig and dig
#LOCALIP=$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | head -n1 | awk '{print $2}' | cut -d':' -f2)
IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

color "37" "Copy the following information and share it with other mining nodes: "
color "32" "
Address: ${address}
IP: ${IP}
"
