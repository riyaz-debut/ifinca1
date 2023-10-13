export FABRIC_CFG_PATH=${PWD}
export CHANNEL_NAME="mychannel"

if [ ! -d "channel-artifacts" ]; then
	mkdir channel-artifacts
fi

if [ ! -d "system-genesis-block" ]; then
	mkdir system-genesis-block
fi

echo
echo "#########  Generating Orderer Genesis block ##############"
configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./system-genesis-block/genesis.block

echo
echo "#########  Generating channel tx ##############"
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME

echo
echo "#########  Anchor peer update ##############"
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/IfincaMSPanchors.tx -channelID $CHANNEL_NAME -asOrg IfincaMSP
