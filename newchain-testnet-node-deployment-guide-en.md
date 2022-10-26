# NewChain TestNet Deployment Guide

## 1. System requirements

### 1.1 Recommended specifications

  - System OS: Ubuntu 18.04 LTS 64-bit or Ubuntu 16.04 LTS 64-bit
  - Processor: 2-core CPU
  - Memory: 8GB RAM
  - Storage: 200GB free space SSD for testnet
  - Internet: Public IP

For server requirements, please refer to AWS m5a.large or Alibaba Cloud ecs.t5

### 1.2 System configuration

  - System data disk: `/data` directory is the mount point of the system data disk
  - Firewall: The firewall needs to open port 38311 for UDP and TCP, and port 8801 for TCP

## 2. Clearing date

**If your computer has never run the NewChain TestNet node, please skip these steps.**

### 2.1 Clear working directory

```bash
$ rm -rf ~/newchain
```

### 2.2 Delete data directory

```bash
$ sudo rm -rf /data/newchain/
```

## 3. Deploying a read-only node

### 3.1 Create a working directory and enter it

```bash
$ mkdir -p newchain && cd newchain
```

### 3.2 Fetch the `newchain.sh` script and run it

```bash
$ curl -L https://release.cloud.diynova.com/newton/newchain-deploy/testnet/newchain.sh | sudo bash
```

### 3.3 View the running log of NewChain

```bash
$ sudo supervisorctl tail -f newchain stderr
```

### 3.4 Make sure the synchronized block height is consistent with the NewExplorer (<a href="https://explorer.testnet.newtonproject.org/">Testnet</a>) latest block height

## 4. Deoloying a ledger node

### 4.1 Execute following command to create miner account

```bash
$ cd /data/newchain/testnet/ && curl -L https://release.cloud.diynova.com/newton/newchain-deploy/testnet/newchain-mine.sh -o newchain-mine.sh && chmod +x newchain-mine.sh && ./newchain-mine.sh
```

### 4.2 Set keystore password

Set keystore password twice and keep keystore, password and miner address. The password shall not be void.

#### 4.2.1 Backup keystore

Run following code to get keystore and store it securely

```bash
$ cat /data/newchain/testnet/nodedata/keystore/*
```

#### 4.2.2 Backup keystore password

Run following code to get password and store it securely

```bash
$ cat /data/newchain/testnet/password.txt
```

You are responsible for storing your keystore and password safely. It’s important to keep your digital assets safe, just like you would your physical assets.

### 4.3 Click the blow link to submit a issue, fill the required information and wait for the existing ledger node to be approved

[Apply for testnet ledger node](https://github.com/newtonproject/newchain-nodes/issues/new?assignees=xiawu&labels=testnet&template=apply-testnet-miner-en.md&title=%3Cnode+name%3E+Apply+for+testnet+ledger+node)

### 4.4 Verify if your own node has become a ledger node

```bash
$ /data/newchain/testnet/bin/geth attach /data/newchain/testnet/nodedata/geth.ipc --exec 'clique.getSigners()'
```

