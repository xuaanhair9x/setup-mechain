#!/bin/bash
[ ! -d "/root/.acme.sh/rpc.mechain.network" ] && ~/.acme.sh/acme.sh --issue --standalone \
  -d rpc.mechain.network \
  -d blockscout.mechain.network \
  -d genesis-config.mechain.network \
  -d config.mechain.network \
  -d explorer.mechain.network \
  -d staking.mechain.network \
  -d faucet.mechain.network || true