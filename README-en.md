# NewChain read-only node deployment guide

## 1. System requirements

### 1.1 Recommended specifications
  - System OS: Ubuntu 18.04 LTS 64-bit or Ubuntu 16.04 LTS 64-bit
  - Processor: 2-core CPU
  - Memory: 8GB RAM
  - Storage: 100GB available space SSD for mainnet and 200GB for testnet
  - Internet: Public IP

For server requirements, please refer to AWS m5a.large or Alibaba Cloud ecs.t5

### 1.2 System Configuration
  - System data disk: /data directory is the mount point of the system data disk
  - Firewall: The firewall needs to open port 38311 of UDP and TCP and port 8801 of TCP

## 2. Installation and deployment

### 2.1 Create a working directory and enter it

```
mkdir -p newchain && cd newchain
```

### 2.2 Fetch the `newchain.sh` script run it

For Mainnet:

```
curl -L https://release.cloud.diynova.com/newton/newchain-deploy/mainnet/newchain.sh | sudo bash
```

For testnet:

```
curl -L https://release.cloud.diynova.com/newton/newchain-deploy/testnet/newchain.sh | sudo bash
```


### 2.3 View NewChain logs

```
sudo supervisorctl tail -f newchain stderr
```

## 3. Use NewChain

- NewChain's external service port is port 8801, HTTP protocol, which can be used as an RPC interface in NewChain SDK.

## 4. Operation and maintenance related operations

- Start NewChain:

```
sudo supervisorctl start newchain
```

- Stop NewChain：

```
sudo supervisorctl stop newchain
```

