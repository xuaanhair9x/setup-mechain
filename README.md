BAS DevNet Setup
================

This repository contains scripts for running an independent instance of BAS.

Before running command you must do following steps:
- Buy a dedicated machine that have at least 8 dedicated CPU core and 32GB RAM (it runs 7 nodes)
- Make sure you have wildcard domain `*.example.com` set to your machine (use dedicated machine with public IP)
- Modify `config.json` file to update parameters you need (you can find all addresses in keystore folder)

Config structure:
- `chainId` - identifier of your BAS chain
- `validators` - list of initial validator set (make sure that you have the same list in docker compose file)
- `systemTreasury` - address of system treasury that accumulates 1/16 of rewards (might be governance)
- `consensusParams` - parameters for the consensus and staking
  - `activeValidatorsLength` - total amount of active validators (suggested values are 3k+1, where k is honest validators, even better, for example 7, 13, 19, 25, 31...)
  - `epochBlockInterval` - better to use 1 day epoch (86400/3=28800, where 3s is block time)
  - `misdemeanorThreshold` - after missing this amount of blocks per day validator losses all daily rewards (penalty)
  - `felonyThreshold` - after missing this amount of blocks per day validator goes in jail for N epochs
  - `validatorJailEpochLength` - how many epochs validator should stay in jail (7 epochs = ~7 days)
  - `undelegatePeriod` - allow claiming funds only after 6 epochs (~7 days)
  - `minValidatorStakeAmount` - how many tokens validator must stake to create a validator (in ether)
  - `minStakingAmount` - minimum staking amount for delegators (in ether)
- `initialStakes` - initial stakes fot the validators (must match with validators list)
- `votingPeriod` - default voting period for the governance proposals
- `faucet` - map with initial balances for faucet and other needs

You can check Makefile to choose the most interesting commands, but if you just need to set up everything just run next command:

```bash
apt update
apt install -y build-essential socat
git clone https://github.com/Ankr-network/bas-devnet-setup bas --recursive
cd bas
make install-docker
make install-acme
export CHAIN_ID=14000
export DOMAIN_NAME=dev-01.bas.ankr.com
make all
```

P.S: Variable `DOMAIN_NAME` should be set to your domain

Deployed services can be access though next endpoints:
- https://rpc.${DOMAIN_NAME} - Web3 RPC endpoint
- https://explorer.${DOMAIN_NAME} - Blockchain Explorer
- https://faucet.${DOMAIN_NAME} - Faucet
- https://staking.${DOMAIN_NAME} - Staking UI

If you want to run node w/o load balancer and SSL certificates then use next command:
```bash
CHAIN_ID=14000 make create-genesis start
```

Docker compose files exposes next ports:
- 30303 - bootnode endpoint
- 8545 - RPC endpoint
- 8546 - WS endpoint
- 3000 - faucet UI
- 3001 - staking UI
- 3002 - config UI 
- 8080 - genesis config endpoint
- 7432 - blockscout PostgreSQL database
- 4000 - blockscout explorer
- 9000 - explorer

    ./build/bin/geth-boot --datadir=/Users/xuanhai/datadir --genesis=/Users/xuanhai/datadir/localnet.json --networkid=17243 --nodekeyhex=633ab917d09441de38ae9251e79ced41df39a1c338842b826c18fb1773246e18 --syncmode=full 

env GO111MODULE=on ~/go/bin/go1.16 run build/ci.go install ./cmd/geth
env GO111MODULE=on ~/go/bin/go1.16 run build/ci.go install ./cmd/geth && mv build/bin/genth build/bin/genth-rpc


  ./build/bin/geth2 --datadir=/Users/xuanhai/datadir1 --genesis=/Users/xuanhai/datadir1/localnet.json --mine --password=/Users/xuanhai/datadir1/password.txt --allow-insecure-unlock --unlock=0x988C239e619053581624dFC99F9Ee61666754DB5 --miner.etherbase=0x988C239e619053581624dFC99F9Ee61666754DB5  --bootnodes=enode://5c8e90050fabb7e14e4921dc107caf533140112245e7a231d0edc49861cd779760ad4804e7034952a5cc79422fa9d31c54e9a6141fb4995af7a6bfce7a39140f@127.0.0.1:30303 --gcmode=archive --syncmode=full --networkid=17243 


  ./build/bin/geth --datadir=/Users/xuanhai/datadir-rpc --genesis=/Users/xuanhai/datadir-rpc/localnet.json  --bootnodes=enode://5c8e90050fabb7e14e4921dc107caf533140112245e7a231d0edc49861cd779760ad4804e7034952a5cc79422fa9d31c54e9a6141fb4995af7a6bfce7a39140f@127.0.0.1:30303 --gcmode=archive --syncmode=full --networkid=17243 --http --http.addr=0.0.0.0 --http.api=eth,net,web3,debug,trace,txpool --http.port=8545 --http.corsdomain="*" --http.vhosts="*" --ws --ws.addr=0.0.0.0 --ws.api=eth,net,web3,debug,trace,txpool --ws.port=8546 --ws.origins="*"

  
env GO111MODULE=on ~/go/bin/go1.16 run build/ci.go install ./cmd/faucet
 ./build/bin/faucet --genesis=/Users/xuanhai/datadir-faucet/localnet.json  --bootnodes=enode://5c8e90050fabb7e14e4921dc107caf533140112245e7a231d0edc49861cd779760ad4804e7034952a5cc79422fa9d31c54e9a6141fb4995af7a6bfce7a39140f@127.0.0.1:30303 --network=17243 --account.json=/Users/xuanhai/datadir-faucet/keystore/UTC--2023-09-30T00-21-07.184957000Z--afc1f92fd4425cc1521ac1344996884c5c006cf5 --account.pass=/Users/xuanhai/datadir-faucet/password.txt --rpcapi=ws://0.0.0.0:8546 --noauth=true --faucet.name=MEC --faucet.amount=10 --faucet.tiers=1