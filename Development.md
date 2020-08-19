# NewChain部署文档

* [NewChain部署文档](README.md)

# NewChain发布说明

## 发布目录结构

NewChain发布包在服务器目录 https://release.cloud.diynova.com/newton/newchain-deploy/{mainnet,testnet}/ 下，
其中，https://release.cloud.diynova.com/newton/ 目录结构如下：

```
Index of /newton/

.
├── newchain
│   ├── latest.txt
│   ├── latest-testnet.txt
│   ├── newton-1.8.26-1.1
│   │   └── linux
│   │       ├── geth
│   │       └── geth.sha256
│   └── tag_name
│       └── linux
│           ├── geth
│           └── geth.sha256
└── newchain-deploy
    ├── mainnet
    │   ├── newchain-mainnet-v1.0.tar.gz
    │   ├── newchain-mainnet-v1.0.tar.gz.sha256
    │   └── newchain.sh
    └── testnet
        ├── newchain.sh
        ├── newchain-testnet-v1.0.tar.gz
        └── newchain-testnet-v1.0.tar.gz.sha256
```

其中，
* /newton/newchain/latest
  * 内容为 NewChain 最新版本号
  * 一般为 [newchain 仓库的tag名](https://gitlab.newtonproject.org/mengguang/newchain/tags)，例如 v1.8.26-newton-1.0， v1.8.26-newton-1.1
  * 需要保证文件 /newton/newchain/tagName/linux/geth 和 /newton/newchain/tagName/linux/geth.sha256 在发布服务上
* /newton/newchain-deploy/mainnet/newchain.sh
  * NewChain主网自动化部署脚本
  * 第9行包含最新版本号
  * 第10行包含当前Network
* /newton/newchain-deploy/testnet/newchain.sh
  * NewChain测试网自动化部署脚本
  * 第9行包含最新版本号
  * 第10行包含当前Network

## 只读节点发布步骤

执行 make 命令后，把 build 目录下所有文件复制到发布服务器 /newton/newchain-deploy/ 目录下。

## 附1： NewChain 升级方法

### 1. 更新newchain二进制程序

基于 [newchain tag](https://gitlab.newtonproject.org/mengguang/newchain/tags) 发布最新版本的二进制程序到目录 /neton/newchain/latestTagName/linux 下

### 2. 更新二进制的shasum

```bash
shasum -a 256 geth > geth.sha256
```

### 3. 更新latest文件

针对 mainnet:
更新 /newton/newchain/latest.txt 里的 newchain 最新版本号为新发布的tag latestTagName

针对 testnet:
更新 /newton/newchain/latest-testnet.txt 里的 newchain 最新版本号为新发布的tag latestTagName



