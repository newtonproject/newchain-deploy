# NewChain部署文档

* [NewChain主网部署文档](NewChainMainnetDeploy.md)

# NewChain发布说明

## 发布目录结构

NewChain发布包在服务器目录 https://release.cloud.diynova.com/newton/newchain-deploy/{mainnet,testnet}/ 下，
其中，https://release.cloud.diynova.com/newton/ 目录结构如下：

```
Index of /newton/

.
├── newchain
│   ├── latest
│   ├── newton-1.8.26-1.1
│   │   └── linux
│   │       ├── geth
│   │       └── geth.sha256
│   └── tag_name
│       └── linux
│           ├── geth
│           └── geth.sha256
└── newchain-deploy
    └── mainnet
        ├── newchain-mainnet-v1.0.tar.gz
        ├── newchain-mainnet-v1.0.tar.gz.sha256
        ├── newchain.sh -> newchain-v1.0.sh
        └── newchain-v1.0.sh
```

其中，
* /newton/newchain/latest
  * 内容为 NewChain 最新版本号
  * 一般为 [newchain 仓库的tag名](https://gitlab.newtonproject.org/mengguang/newchain/tags)，例如 newton-v1.8.26-1.0， newton-1.8.26-1.1
  * 需要保证文件 /newton/newchain/tagName/linux/geth 和 /newton/newchain/tagName/linux/geth.sha256 在发布服务上
* /newton/newchain-deploy/mainnet/newchain.sh
  * NewChain主网自动化部署脚本
  * 第9行包含最新版本号

## 只读节点发布步骤

### 1. 更新mainnet里文件

mainnet目录结构如下：

```
mainnet/
├── conf
│   └── node.toml
├── share
│   └── newchainmain.json
└── supervisor
    └── newchain.conf
```

### 2. 创建压缩包

以当前最新版本号为例：v1.0

```bash
tar czvf newchain-mainnet-v1.0.tar.gz mainnet/
```

### 3. 获取shasum值

```bash
shasum -a 256 newchain-mainnet-v1.0.tar.gz > newchain-mainnet-v1.0.tar.gz.sha256
```

### 4. 复制 tar.gz 文件

* 复制 `newchain-mainnet-v1.0.tar.gz` 和 `newchain-mainnet-v1.0.tar.gz.sha256` 到发布服务器 /newton/newchain-deploy/mainnet 目录下

### 5. 复制 newchain.sh 文件

* 复制 `newchain.sh` 到发布服务器 /newton/newchain-deploy/mainnet 目录下，或者命名为 `newchain-v1.0.sh` 后软连接到 `newchain.sh`
* 更新 `nwechain.sh` 文件里第9行 `newchain_deploy_latest_version`值为最新版本号，例如： v1.0

## 附1： NewChain 升级方法

### 1. 更新newchain二进制程序

基于 [newchain tag](https://gitlab.newtonproject.org/mengguang/newchain/tags) 发布最新版本的二进制程序到目录 /neton/newchain/latestTagName/linux 下

### 2. 更新二进制的shasum

```bash
shasum -a 256 geth > geth.sha256
```

### 3. 更新latest文件

更新 /newton/newchain/latest 里的 newchain 最新版本号为新发布的tag latestTagName


