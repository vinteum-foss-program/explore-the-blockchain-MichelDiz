#!/bin/bash

# How many new outputs were created by block 123,456?

# Alteração para evitar problemas com CI
if [[ "$(uname)" == "Darwin" ]]; then
  pathconf="-conf=/Users/micheldiz/.bitcoin/bitcoin.conf"
else
  pathconf=""
fi

block_hash=$(bitcoin-cli $pathconf getblockhash 123456)
txns=$(bitcoin-cli $pathconf getblock $block_hash | jq -r '.tx[]')

total_outputs=0

for tx in $txns; do
  outputs=$(bitcoin-cli $pathconf getrawtransaction $tx 1 | jq '.vout | length')
  total_outputs=$((total_outputs + outputs))
done

# Exibir o total de saídas
echo $total_outputs

#24
