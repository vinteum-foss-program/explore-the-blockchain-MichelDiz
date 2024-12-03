#!/bin/bash

# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`

if [[ "$(uname)" == "Darwin" ]]; then
  pathconf="-conf=/Users/micheldiz/.bitcoin/bitcoin.conf"
else
  pathconf=""
fi

# Chaves públicas
keys=()

txid="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"
raw_tx=$(bitcoin-cli $pathconf getrawtransaction $txid 1)

# Coletar as chaves públicas
while read -r witness; do
  if [[ "$witness" =~ ^0[23][0-9a-fA-F]{64}$ ]]; then
    # echo "Chave pública encontrada: $witness"
    keys+=("$witness")
  fi
done < <(echo "$raw_tx" | jq -r '.vin[].txinwitness[]')

keys_json=$(printf '"%s",' "${keys[@]}" | sed 's/,$//')

# Criar o endereço multisig
result=$(bitcoin-cli $pathconf createmultisig 1 "[$keys_json]")

address=$(echo "$result" | jq -r '.address')
echo "$address"
