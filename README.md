# NewChain部署文档

* [NewChain主网部署文档](NewChainMainnetDeploy.md)

# NewChain发布说明

## 发布目录结构

NewChain发布包在服务器目录 https://release.cloud.diynova.com/newton/newchain-deploy/{mainnet,testnet}/ 下，
mainnet该目录结构如下：

```
Index of /newton/newchain/newchain-deploy/mainnet/
.
├── latest
├── newchain-mainnet-<version>.tar.gz
├── newchain-mainnet-<version>.tar.gz.sha256
└── newchain.sh
```

其中，
* latest包含当前最新版本号，例如 v1.8.26，v1.8.26-1.0，newton-v1.8.26-1.0
* newchain-mainnet-<version>.tar.gz 里的 version 为 latest 文件的内容
* newchain.sh 自动化部署脚本

## 只读节点发布步骤

1. 更新mainnet里文件

mainnet目录结构如下：

```
mainnet/
├── bin
│   └── geth
├── conf
│   └── node.toml
├── share
│   └── newchainmain.json
└── supervisor
    └── newchain.conf
```

如有需要，更改对应文件

2. 创建压缩包

以当前最新版本号为例：newton-1.8.26-1.1

```bash
tar czvf newchain-mainnet-newton-1.8.26-1.1.tar.gz mainnet/
```

3. 获取shasum值

```bash
shasum -a 256 newchain-mainnet-newton-1.8.26-1.1.tar.gz > newchain-mainnet-newton-1.8.26-1.1.tar.gz.sha256
```

4. 复制文件

复制 `newchain-mainnet-newton-1.8.26-1.1.tar.gz` 和 `newchain-mainnet-newton-1.8.26-1.1.tar.gz.sha256`
到发布服务 https://release.cloud.diynova.com/newton/newchain-deploy/mainnet 对应的目录下

5. 更新latet

更新 https://release.cloud.diynova.com/newton/newchain-deploy/mainnet/latest 对应的文件内容为最新版本 newton-1.8.26-1.1




