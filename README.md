# NewChain node deployment guide

## 1. System requirements

### 1.1 Recommended specifications
  - System OS: Ubuntu 24.04 LTS x86_64
  - Processor: 2-core CPU
  - Memory: 16GB RAM
  - Storage: 200GB available space SSD
  - Internet: Public IP

For server requirements, please refer to AWS r7a.large or r7i.large.

### 1.2 System Configuration
  - System data disk: /data directory is the mount point of the system data disk
  - Firewall: The firewall needs to open port 38311 of UDP and TCP, 8801 of TCP.
  - Firewall: Mining node should open port 38311 of UDP and TCP.

## 2. Installation and deployment

### 2.1 Create a working directory and enter it

```
mkdir -p newchain && cd newchain
```

### 2.2 Fetch the `newchain.sh` script run it

For Mainnet:

```
git clone https://github.com/newtonproject/newchain-deploy
cd newchain-deploy
make
cd build/mainnet
sudo bash newchain.sh
```

for Testnet, `cd build/testnet && sudo bash newchain.sh`

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

