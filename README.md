### NewChain节点部署

1. 服务器环境要求

1.1 最小配置
  - 操作系统： 64-bit Linux/Ubuntu
  - 处理器： Intel Core i5–760 or AMD FX-8100 or better
  - 内存： 4GB
  - 存储： 50 GB可用空间
  - 网络： 有公网IP

1.2 推荐配置
  - 操作系统： Ubuntu 18.04 x86_64
  - 处理器： Intel Core i7–4770 or AMD FX-8310 or better， 8GB
  - 内存： 32 GB
  - 存储： 200 GB可用空间
  - 网络： 有公网IP

参考 AWS m5.2xlarge 或更高规则配置。

2. 安装部署

2.1 创建工作目录并输入

```
mkdir -p newchain && cd newchain
```

2.2 从Github获取安装脚本程序`newchain.sh`并运行

```
curl -L http://47.75.82.30/releases/newchain.sh | sudo bash
```

2.3 查看NewChain服务日志
```
sudo supervisorctl tail -f newchain stderr
```

3. 使用NewChain服务

- NewChain对外服务端口为 8545 端口，HTTP协议，可以作为RPC接口在NewChain SDK中使用。

4. 运维相关操作

- 启动服务：

```
sudo supervisorctl start newchain
```

- 停止服务：

```
sudo supervisorctl stop newchain
```

