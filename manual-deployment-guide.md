# Manually setup a NewChain read-only node WITHOUT root privilege

**无需root权限手工运行NewChain只读节点**

The original tutorial requires sudo privilege to install and run a newchain read-only node.

This short how-to tells about how to do it with a normal user account.

## Preparation

1. Hardware
    - 8GB memory or more (it is really memory hungry)
    - 100GB storage or more
2. OS
    - Ubuntu 20.04 LTS

## Create working directory /home/newchain

```
$ cd ~
$ mkdir newchain
$ cd newchain
```

## Download runtime and configurations

Know the latest version:
```
$ wget https://release.cloud.diynova.com/newton/newchain/latest.txt
$ export newchain_version=`cat latest.txt`
```

Download the runtime
```
$ wget https://release.cloud.diynova.com/newton/newchain/${newchain_version}/linux/geth
$ wget https://release.cloud.diynova.com/newton/newchain/${newchain_version}/linux/geth.sha256
```
and verify it:
```
$ sha256sum -c geth.sha256
```
then make it executable:
```
$ chmod +x geth
```

Download the configuraiton pack
```
$ export newchain_deploy_latest_version="v20200526"
$ export newchain_mainnet_deploy_file="newchain-mainnet-$newchain_deploy_latest_version.tar.gz"
$ wget https://release.cloud.diynova.com/newton/newchain-deploy/mainnet/${newchain_mainnet_deploy_file}
$ wget https://release.cloud.diynova.com/newton/newchain-deploy/mainnet/${newchain_mainnet_deploy_file}.sha256
```
and verify it:
```
$ sha256sum -c ${newchain_mainnet_deploy_file}.sha256
```
then unpack it:
```
$ tar xvfz newchain-mainnet-v20200526.tar.gz
```

## Create the data directory and initialize it

```
$ mkdir mainnet/nodedata
$ ./geth --datadir ./mainnet/nodedata init mainnet/share/newchainmain.json
```

## Edit the configuration file

Modify mainnet/conf/node.toml with the following changes:
1. Change DatasetDir to /home/{USERNAME}/newchain/.ethash
2. Change DataDir to /home/{USERNAME}/newchain/mainnet/nodedata

Please replace the {USERNAME} above with your linux account name.

## Start the node

```
$ ./geth --config ./mainnet/conf/node.toml
```

Bingo. You should have seen the node is started to download the blockchain data.

## Connect to the node and check the status

```
$ ./geth attach ~/newchain/mainnet/nodedata/geth.ipc
```

Type eth.syncing and you'll see:
```
> eth.syncing
{
  currentBlock: 88412,
  highestBlock: 15596231,
  knownStates: 0,
  pulledStates: 0,
  startingBlock: 0
}
```

Well done.

## Reference

https://github.com/newtonproject/newchain-deploy

## Author

[Evan Liu](https://github.com/evanliuchina)
