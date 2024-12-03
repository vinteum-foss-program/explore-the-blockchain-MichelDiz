#!/bin/bash
# Which tx in block 257,343 spends the coinbase output of block 256,128?

if [[ "$(uname)" == "Darwin" ]]; then
  pathconf="-conf=/Users/micheldiz/.bitcoin/bitcoin.conf"
else
  pathconf=""
fi

cb_txid=$(bitcoin-cli $pathconf getblock $(bitcoin-cli $pathconf getblockhash 256128) | jq -r '.tx[0]')
txs=$(bitcoin-cli $pathconf getblock $(bitcoin-cli $pathconf getblockhash 257343) | jq -r '.tx[]')

for tx in $txs; do
  spent=$(bitcoin-cli $pathconf getrawtransaction $tx 1 | jq -r ".vin[] | select(.txid == \"$cb_txid\")")
  if [ ! -z "$spent" ]; then
    echo $tx
    break
  fi
done

#c54714cb1373c2e3725261fe201f267280e21350bdf2df505da8483a6a4805fc
