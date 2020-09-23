
## 如何查看当前节点同步情况？

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

```json
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




