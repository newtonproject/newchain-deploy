
## 1. 如何查看当前节点同步情况？

### 方法一

1.执行命令：

```bash
sudo supervisorctl tail -f newchain stderr
```

可查看日志及已同步好的区块高度（number字段对应值）。

2. 对比上述已同步好的区块高度与测试网区块链浏览器 https://explorer.testnet.newtonproject.org/ 显示的最新区块高度对比，即可知是否完成同步。

### 方法二

执行命令：

```
/data/newchain/testnet/bin/geth attach /data/newchain/testnet/nodedata/geth.ipc --exec eth.syncing
```

* 如果已经同步成功，则返回 false
* 如果还在同步，则显示同步进程

```
{
  currentBlock: 800454,
  highestBlock: 18508008,
  knownStates: 0,
  pulledStates: 0,
  startingBlock: 0
}
```

其中，
* currentBlock: 本节点的区块高度
* highestBlock: 整个网络最高区块高度


## 2. 如何更改记账节点收益地址keystore对应的密码？

2.1 查询之前Keystore密码

如果忘记您之前的密码， 输入命令 `cat /data/newchain/testnet/password.txt`

2.2 更改密码

假设您的记账节点地址为 0x1111111111111111111111111111111111111111， 新密码为 `123456`

替换如下命令中的 `0x1111111111111111111111111111111111111111` 为您自己的记账节点地址，执行该命令

```bash
/data/newchain/testnet/bin/geth --nousb --config /data/newchain/testnet/conf/node.toml account update 0x1111111111111111111111111111111111111111
```
该命令为更改keystore密码，您需要先输入您之前的密码
之后输入您的新密码 `123456`

2.3 替换 password.txt 密码

执行如下命令：

```bash
echo "123456" > /data/newchain/testnet/password.txt
```

- 重启 NewChain

```bash
sudo supervisorctl restart newchain
```

- 查看日志

```bash
sudo supervisorctl tail -f newchain stderr
```
