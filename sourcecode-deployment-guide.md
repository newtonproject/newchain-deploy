# Build NewChain source code and Setup a NewChain read-only node

**从编译newchain源码到运行一个只读节点**

## Preparation

System:
1. Hardware
    - 8GB memory or more (it is really memory hungry)
    - 100GB storage or more
2. OS
    - Ubuntu 20.04 LTS


Install git
```
$ sudo apt-get install git
```

Install golang
```
$ sudo apt-get install golang build-essential
```

## Download the source code

```
$ mkdir git && cd git
$ git clone https://github.com/newtonproject/newchain.git
```

## Build

```
$ cd newchain
$ make
```

Done. You now have build/bin/geth.

## Install geth to /usr/local/bin

```
$ cp ~/git/newchain/build/bin/geth /usr/local/bin/
```

## Prepare the data folder

Mount the data partition to, for example, /data/

Create a data folder:

```
$ mkdir /data/newchain
```

Be careful about the access permissions of the data folder.

Symbol link it to your home folder:

```
$ ln -s /data/newchain ~/.newchain
```

## Initialize the data folder

```
$ mkdir ~/.newchain/mainnet
```

Create file ~/.newchain/mainnet/genesis.json:
```
{
  "config": {
    "chainId": 1012,
    "homesteadBlock": 1,
    "eip150Block": 2,
    "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "eip155Block": 3,
    "eip158Block": 3,
    "byzantiumBlock": 4,
    "clique": {
      "period": 3,
      "epoch": 30000
    }
  },
  "nonce": "0x0",
  "timestamp": "0x5bc41533",
  "extraData": "0x000000000000000000000000000000000000000000000000000000000000000046212dab2792d6e44b70ae8f3bf103291e659d4f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  "gasLimit": "100000000",
  "difficulty": "0x1",
  "mixHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "alloc": {
    "1a72624202aa0db93fa0f252039517f4fabe4f66": {
      "balance": "100000000000000000000000000000"
    }
  },
  "number": "0x0",
  "gasUsed": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000"
}
```

```
$ geth --datadir ~/.newchain/mainnet init ~/.newchain/mainnet/genesis.json
```

Notice that two folders are created: geth/ and keystore/

## Run a newchain read-only node

Create a config file ~/.newchain/mainnet/config.toml:

```
[Eth]
NetworkId = 1012
SyncMode = "full"
LightPeers = 100
DatabaseCache = 768
#GasPrice = 1
MinerGasPrice = 1
EnablePreimageRecording = false

[Eth.Ethash]
CacheDir = "ethash"
CachesInMem = 2
CachesOnDisk = 3
DatasetDir = "/home/evan/.newchain/.ethash"
DatasetsInMem = 1
DatasetsOnDisk = 2
PowMode = 0

[Eth.TxPool]
NoLocals = true
Journal = "transactions.rlp"
Rejournal = 300000000000
PriceLimit = 1000000000
PriceBump = 10
AccountSlots = 4096
GlobalSlots = 16384
AccountQueue = 64
GlobalQueue = 1024
Lifetime = 10800000000000

[Eth.GPO]
Blocks = 20
Percentile = 60

[Shh]
MaxMessageSize = 1048576
MinimumAcceptedPOW = 2e-01

[Node]
DataDir = "/home/evan/.newchain/mainnet"
IPCPath = "/tmp/geth.ipc"
HTTPHost = "127.0.0.1"
HTTPPort = 8801
HTTPVirtualHosts = ["localhost"]
HTTPModules = ["eth", "txpool", "net", "debug"]
WSPort = 8546
WSModules = ["net", "web3", "eth", "shh"]

[Node.P2P]
MaxPeers = 25
NoDiscovery = false
BootstrapNodes = ["enode://503ad5186aba1a72e727afba9234fa785cf207eb9e21182c35e83f2d0cd342366edce7eb711ddbdbdaa99356eaf9ff0a90139119d06e463a55777076fb6ee8f4@47.57.101.140:38311", "enode://e4b028f6c3f8981c37b360451132a830a4308157ed550237751e20d00026f5efecdff209438741fbd015b3aefe119b16cbd5840620caf9bf2f7ac941aa1ff649@54.249.167.30:38311", "enode://bd2672d9ef15e2e882d4e64dd938d5c336d06800c7242d15ac037f645f1256598ecf6549415c58f5afe647b283b5f8b76fc3235a3e61c143f947b39d8523469c@138.91.12.246:38311"]
BootstrapNodesV5 = ["enode://503ad5186aba1a72e727afba9234fa785cf207eb9e21182c35e83f2d0cd342366edce7eb711ddbdbdaa99356eaf9ff0a90139119d06e463a55777076fb6ee8f4@47.57.101.140:38311", "enode://e4b028f6c3f8981c37b360451132a830a4308157ed550237751e20d00026f5efecdff209438741fbd015b3aefe119b16cbd5840620caf9bf2f7ac941aa1ff649@54.249.167.30:38311", "enode://bd2672d9ef15e2e882d4e64dd938d5c336d06800c7242d15ac037f645f1256598ecf6549415c58f5afe647b283b5f8b76fc3235a3e61c143f947b39d8523469c@138.91.12.246:38311"]
StaticNodes = []
TrustedNodes = []
ListenAddr = ":38311"
EnableMsgEvents = false

[Dashboard]
Host = "localhost"
Port = 8080
Refresh = 5000000000
```

Please note that geth.ipc must be on a Linux filesystem (cannot be on FAT32).

Start the node:

```
$ geth --config ~/.newchain/mainnet/config.toml
```

It works!

## Connect to the node and play with it

```
$ geth attach /tmp/geth.ipc
> eth.blockNumber
15797604
```

Well done.

## Reference

- https://github.com/newtonproject/newchain-deploy
- https://github.com/newtonproject/newchain

## Author

[Evan Liu](https://github.com/evanliuchina)
