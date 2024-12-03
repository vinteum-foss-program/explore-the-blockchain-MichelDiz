#!/bin/bash

# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`

#! 025d524ac7ec6501d018d322334f142c7c11aa24b9cffec03161eca35a1e32a71f

if [[ "$(uname)" == "Darwin" ]]; then
  pathconf="-conf=/Users/micheldiz/.bitcoin/bitcoin.conf"
  Local=${1:-false}
else
  pathconf=""
fi

txid="e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163"

raw_tx=$(bitcoin-cli $pathconf getrawtransaction $txid 1)


if [[ "$Local" == true ]]; then
    echo " Start... "
    echo "$raw_tx" | jq -r '.vin[0].txinwitness'
fi

#Simplificando extração das testemunha.
txinwitness=$(echo "$raw_tx" | jq -r '.vin[0].txinwitness')
signature=$(echo "$txinwitness" | jq -r '.[0]')
redeem_script=$(echo "$txinwitness" | jq -r '.[-1]') #gerallmente o ultimo dado


if [[ "$Local" == true ]]; then
   echo "Redeem Script => $redeem_script"
    echo "Signature => $signature"
fi

decoded=$(bitcoin-cli $pathconf decodescript "$redeem_script")
asm=$(echo "$decoded" | jq -r '.asm')

if [[ "$Local" == true ]]; then
   echo "ASM => $asm"
fi

pubkey1=$(echo "$asm" | awk '{print $2}')
pubkey2=$(echo "$asm" | awk '{print $6}')
op_if_condition=$(echo "$asm" | awk '{print $1}')

# Vamos determinar qual das chaves foram usadas
if [[ "$op_if_condition" == "OP_IF" ]]; then
  signed_pubkey="$pubkey1"
else
  signed_pubkey="$pubkey2"
fi

echo "$signed_pubkey"
