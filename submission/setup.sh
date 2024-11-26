wget https://bitcoincore.org/bin/bitcoin-core-27.1/bitcoin-27.1-arm64-apple-darwin.tar.gz
tar -xzvf bitcoin-27.1-arm64-apple-darwin.tar.gz
sudo cp bitcoin-27.1/bin/* /usr/local/bin/
# brew install wget
# brew install jq

mkdir -p ~/.bitcoin
echo "rpcconnect=84.247.182.145" >> ~/.bitcoin/bitcoin.conf
echo "rpcuser=classroom" >> ~/.bitcoin/bitcoin.conf
echo "rpcpassword=R4uo1NgQGuFx" >> ~/.bitcoin/bitcoin.conf
