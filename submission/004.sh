#!/bin/bash
# Using descriptors, compute the taproot address at index 100 derived from this extended public key:
#   `xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2`

if [[ "$(uname)" == "Darwin" ]]; then
  pathconf="-conf=/Users/micheldiz/.bitcoin/bitcoin.conf"
else
  pathconf=""
fi

descriptor="tr(xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2/100)"
descriptor_with_checksum=$(bitcoin-cli $pathconf getdescriptorinfo "$descriptor" | jq -r '.descriptor')

# Derivar o endereço Taproot
addr=$(bitcoin-cli $pathconf deriveaddresses "$descriptor_with_checksum")

first_addr=$(echo "$addr" | jq -r '.[0]')

echo $first_addr
