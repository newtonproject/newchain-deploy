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
- 防火墙： 防火墙需要打开 UDP 和 TCP 的 38311 端口，以及 TCP 的 8808 端口

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

#### 2. 获取安装脚本程序`newchain.sh`并运行

```bash
$ curl -L https://release.cloud.diynova.com/newton/newchain-deploy/testnet/newchain.sh | sudo bash
```

#### 3. 查看 NewChain 运行日志

```bash
$ sudo supervisorctl tail -f newchain stderr
```

#### 4. 确认已经同步到最新块

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
/data/newchain/testnet/bin/geth attach /data/newchain/testnet/nodedata/geth.ipc --exec 'clique.getSigners()'
```

