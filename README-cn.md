# NewChain节点部署方法

## 1. 服务器环境要求

### 1.1 最小配置
  - 操作系统：Ubuntu 18.04 LTS 64位 或 Ubuntu 16.04 LTS 64位
  - 处理器： 2核心 CPU
  - 内存： 8GB
  - 存储： 主网需要 150 GB可用存储空间， 测试网需要 150 GB 可用存储空间
  - 网络： 公网IP

服务器配置可参考 AWS m5a.large 或 阿里云 ecs.t5

### 1.2 系统配置
  - 系统数据盘挂载： /data 目录为系统数据盘的挂载点
  - 防火墙： 防火墙需要打开 UDP 和 TCP 的 38311 端口 以及 TCP 的 8801 端口

## 2. 安装部署

### 2.1 创建工作目录并输入

```
mkdir -p newchain && cd newchain
```

### 2.2 获取安装脚本程序`newchain.sh`并运行

主网:

```
git clone https://github.com/newtonproject/newchain-deploy
cd newchain-deploy
make main
cd build/mainnet
sudo bash newchain.sh
```

针对测试网，`cd build/testnet && sudo bash newchain.sh`

### 2.3 查看NewChain服务日志

```
sudo supervisorctl tail -f newchain stderr
```

## 3. 使用NewChain服务

- NewChain对外服务端口为 8801 端口，HTTP协议，可以作为RPC接口在NewChain SDK中使用。

## 4. 运维相关操作

- 启动服务：

```
sudo supervisorctl start newchain
```

- 停止服务：

```
sudo supervisorctl stop newchain
```

