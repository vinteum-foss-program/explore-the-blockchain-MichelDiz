#!/bin/bash
# What is the hash of block 654,321?

# Alteração para evitar problemas com CI
if [[ "$(uname)" == "Darwin" ]]; then
  pathconf="-conf=/Users/micheldiz/.bitcoin/bitcoin.conf"
else
  pathconf=""
fi

bitcoin-cli $pathconf getblockhash 654321

#000000000000000000058452bbe379ad4364fe8fda68c45e299979b492858095
