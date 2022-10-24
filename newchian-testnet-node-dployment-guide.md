# NewChain测试网节点部署方法

### 一. 系统需求

### 1.1 最小配置

- 操作系统：Ubuntu 18.04 LTS 64位 或 Ubuntu 16.04 LTS 64位
- 处理器： 2核心 CPU
- 内存： 8GB
- 存储： 测试网需要 200 GB 可用存储空间
- 网络： 公网IP

服务器配置可参考 AWS m5a.large 或 阿里云 ecs.t5

### 1.2 系统配置

- 系统数据盘挂载： /data 目录为系统数据盘的挂载点
- 防火墙： 防火墙需要打开 UDP 和 TCP 的 38311 端口，以及 TCP 的 8801 端口

### 二. 清除数据

**如果你的机器没有运行过NewChain TestNet节点，请忽略这步。**

#### 1. 清除工作目录

```bash
$ rm -rf ~/newchain
```

#### 2. 删除数据目录

```bash
$ sudo rm -rf /data/newchain/
```

### 三. 部署只读节点

#### 1. 创建工作目录

```bash
$ mkdir -p ~/newchain && cd ~/newchain
```

#### 2. 获取安装脚本程序`newchain.sh`

##### 2.1 获取安装脚本

```bash
$ curl -L https://release.cloud.diynova.com/newton/newchain-deploy/testnet/newchain.sh -o newchain.sh && chmod +x newchain.sh
```

##### 2.2 修改 `newchain.sh`

###### 2.2.1 注释 第155-158行代码

```bash
  # supervisorctl restart newchain || {
  #   color "31" "Failed to restart newchain by supervisor."
  #   exit 1
  # }
```

###### 2.2.2 注释`newchain.sh`第322-335行代码

```bash
# if [[ ! -x /data/newchain/${networkname}/nodedata/geth/ ]]; then
#   color "37" "Trying to init the NewChain node data directory..."
#   /data/newchain/${networkname}/bin/geth --config /data/newchain/${networkname}/conf/node.toml --datadir /data/newchain/${networkname}/nodedata init /data/newchain/${networkname}/share/newchain${networkname}.json  || {
#     color "31" "Failed to init the NewChain node data directory."
#     exit 1
#   }
# else
#   # force re-init nodedata
#   color "37" "Trying to re-init the NewChain node data directory..."
#   /data/newchain/${networkname}/bin/geth --config /data/newchain/${networkname}/conf/node.toml --datadir /data/newchain/${networkname}/nodedata init /data/newchain/${networkname}/share/newchain${networkname}.json  || {
#     color "31" "Failed to re-init the NewChain node data directory."
#     exit 1
#   }
# fi
```

###### 2.2.3 注释`newchain.sh`第367-381行代码

```bash
# newchainstatus="$(supervisorctl status newchain | awk '{print $2}')"
# if [[ "${newchainstatus}" != "RUNNING" && "${newchainstatus}" != "STARTING" ]]; then
#   supervisorctl start newchain || {
#     color "31" "Failed to exec supervisorctl start newchain."
#     exit 1
#   }
# fi

# newchainguardstatus="$(supervisorctl status newchainguard | awk '{print $2}')"
# if [[ "${newchainguardstatus}" != "RUNNING" && "${newchainguardstatus}" != "STARTING" ]]; then
#   supervisorctl start newchainguard || {
#     color "31" "Failed to exec supervisorctl start newchainguard."
#     exit 1
#   }
# fi
```

##### 2.3 执行脚本

```bash
$ sudo ./newchain.sh
```

#### 3. 启动节点

##### 3.1 更新 node.toml

```bash
$ echo '[Eth]
NetworkId = 1007
SyncMode = "full"
DiscoveryURLs = []
NoPruning = false
NoPrefetch = false
LightPeers = 100
UltraLightFraction = 75
DatabaseCache = 512
DatabaseFreezer = ""
TrieCleanCache = 256
TrieDirtyCache = 256
TrieTimeout = 3600000000000
SnapshotCache = 0
EnablePreimageRecording = false
EWASMInterpreter = ""
EVMInterpreter = ""
RPCGasCap = 0
RPCTxFeeCap = 0e+00

[Eth.Miner]
GasFloor = 100000000
GasCeil = 8000000
GasPrice = 500000000000000
Recommit = 3000000000
Noverify = false

[Eth.TxPool]
Locals = []
NoLocals = true
Journal = "transactions.rlp"
Rejournal = 300000000000
PriceLimit = 500000000000000
PriceBump = 10
AccountSlots = 4096
GlobalSlots = 4096
AccountQueue = 64
GlobalQueue = 1024
Lifetime = 10800000000000

[Eth.GPO]
Blocks = 20
Percentile = 60

[Shh]
MaxMessageSize = 1048576
MinimumAcceptedPOW = 2e-01
RestrictConnectionBetweenLightClients = true

[Node]
DataDir = "/data/newchain/testnet/nodedata"
NoUSB = true
IPCPath = "geth.ipc"
HTTPHost = "127.0.0.1"
HTTPPort = 8808
HTTPCors = ["*"]
HTTPVirtualHosts = ["*"]
HTTPModules = ["eth", "txpool", "net"]
WSHost = ""
WSPort = 8546
WSModules = ["net", "web3", "eth"]
GraphQLHost = ""
GraphQLPort = 8547
GraphQLVirtualHosts = ["localhost"]

[Node.P2P]
MaxPeers = 25
NoDiscovery = false
BootstrapNodes = ["enode://0a4cf1b2f21f1caae594aea2c9a2ffced3db9bd71f595f9273a6ef2fbc11d68dd0f12867bddb0ca20a9157e11b20bbd4b755a4b28a3515583ac9327c528a5ffe@18.178.210.219:38311"]
BootstrapNodesV5 = ["enode://0a4cf1b2f21f1caae594aea2c9a2ffced3db9bd71f595f9273a6ef2fbc11d68dd0f12867bddb0ca20a9157e11b20bbd4b755a4b28a3515583ac9327c528a5ffe@18.178.210.219:38311"]
StaticNodes = []
TrustedNodes = []
ListenAddr = ":38311"
EnableMsgEvents = false

[Node.HTTPTimeouts]
ReadTimeout = 30000000000
WriteTimeout = 30000000000
IdleTimeout = 120000000000' > /data/newchain/testnet/conf/node.toml
```

##### 3.2 更新 newchaintestnet.json

```bash
$ echo '{
  "config": {
    "chainId": 1007,
    "homesteadBlock": 1,
    "eip150Block": 2,
    "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "eip155Block": 3,
    "eip158Block": 3,
    "byzantiumBlock": 4,
    "constantinopleBlock": 10,
    "petersburgBlock": 10,
    "istanbulBlock": 10,
    "clique": {
      "period": 3,
      "epoch": 30000
    }
  },
  "nonce": "0x0",
  "timestamp": "0x60471d42",
  "extraData": "0x00000000000000000000000000000000000000000000000000000000000000001d7e06ad19339263a51ee47e11b4ffd10d4a83ba0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  "gasLimit": "100000000",
  "difficulty": "0x1",
  "mixHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "alloc": {
    "1d7e06ad19339263a51ee47e11b4ffd10d4a83ba": {
      "balance": "100000000000000000000000000000"
    }
  },
  "number": "0x0",
  "gasUsed": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000"
}' > /data/newchain/testnet/share/newchaintestnet.json
```

##### 3.3 初始化节点

```bash
$ /data/newchain/testnet/bin/geth --config /data/newchain/testnet/conf/node.toml --datadir /data/newchain/testnet/nodedata init /data/newchain/testnet/share/newchaintestnet.json
```

##### 3.4 启动 NewChain

```bash
$ sudo supervisorctl start newchain
$ sudo supervisorctl start newchainguard
```

#### 5. 查看 NewChain 运行日志

```bash
$ sudo supervisorctl tail -f newchain stderr
```

#### 6. 确认已经同步到最新块

确认日志中已同步的块和浏览器中最新块一致，TestNet浏览器：https://explorer.testnet.newtonproject.org/

### 四. 部署记账节点

#### 1. 运行下面命令，创建矿工账户

```bash
$ cd /data/newchain/testnet/ && curl -L https://release.cloud.diynova.com/newton/newchain-deploy/testnet/newchain-mine.sh -o newchain-mine.sh && chmod +x newchain-mine.sh && ./newchain-mine.sh
```

#### 2. 设置keystore密码

运行完1中的命令，会提示你输入两次keystore密码，备份好矿工地址、keystore密码和keystore文件。keystore文件在 `/data/newchain/testnet/nodedata/keystore/` 目录下。

- 备份keystore

  输入如下命令，获取keystore内容

  ```bash
  $ cat /data/newchain/testnet/nodedata/keystore/*	
  ```

​		keystore为整个大括号及其包含的内容，需要备份好，切勿泄露给任何人。

- 备份keystore的密码

  输入如下命令，获取密码

  ```bash
  $ cat /data/newchain/testnet/password.txt
  ```

  备份好密码，切勿泄露给任何人。

#### 3. 点击下面链接提交"申请成为测试网记账节点"的issue

​	[申请成为测试网记账节点](https://github.com/newtonproject/newchain-nodes/issues/new?assignees=xiawu&labels=testnet&template=apply-testnet-miner-cn.md&title=%3C%E8%8A%82%E7%82%B9%E5%90%8D%E7%A7%B0%3E+%E7%94%B3%E8%AF%B7%E6%88%90%E4%B8%BA%E6%B5%8B%E8%AF%95%E7%BD%91%E8%AE%B0%E8%B4%A6%E8%8A%82%E7%82%B9)

#### 4. 等待其他节点批准加入，你可以通过下面命令查看是否成为记账节点

```bash
$ /data/newchain/testnet/bin/geth attach /data/newchain/testnet/nodedata/geth.ipc --exec 'clique.getSigners()'
```

