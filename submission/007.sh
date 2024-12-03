#!/bin/bash

# Only one single output remains unspent from block 123,321. What address was it sent to?

if [[ "$(uname)" == "Darwin" ]]; then
  pathconf="-conf=/Users/micheldiz/.bitcoin/bitcoin.conf"
  Local=${1:-false}
else
  pathconf=""
fi

blockhash=$(bitcoin-cli $pathconf getblockhash 123321)
txs=$(bitcoin-cli $pathconf getblock $blockhash | jq -r '.tx[]')

for txid in $txs; do
    if [[ "$Local" == true ]]; then
       echo "txn: $txid"
    fi
  raw_tx=$(bitcoin-cli $pathconf getrawtransaction $txid 1)
  
  # Iterar sobre cada vout da transação
  echo "$raw_tx" | jq -c '.vout[]' | while read -r vout; do
    value=$(echo "$vout" | jq '.value')
    scriptPubKey=$(echo "$vout" | jq -r '.scriptPubKey.hex')
    
    # Verificar se o vout está não gasto
    n=$(echo "$vout" | jq '.n')
    is_unspent=$(bitcoin-cli $pathconf gettxout "$txid" "$n")
    
    if [[ -n "$is_unspent" ]]; then
      address=$(echo "$vout" | jq -r '.scriptPubKey.address')
      echo "$address"
    #   echo "  Valor: $value BTC"
    fi
  done
done
