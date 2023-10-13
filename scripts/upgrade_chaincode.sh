#!/bin/bash

#Create and join channel
export CHANNEL_NAME=mychannel
export VERSION=$1
export CC_NAME=ifinca_chaincode
export ORDERER_CA=${PWD}/crypto/ordererOrganizations/ifinca/orderers/orderer0-ifinca/msp/tlscacerts/tlsca-cert.pem

echo "Install Chaincode on peer 0"
echo
peer chaincode install -n $CC_NAME -v $VERSION -p github.com/chaincode/ifinca/cmd

echo
echo "Install Chaincode on peer 1"
echo
export CORE_PEER_ADDRESS=peer1-ifinca:8051
peer chaincode install -n $CC_NAME -v $VERSION -p github.com/chaincode/ifinca/cmd

echo
echo "instantiate Chaincode on peer 0"
echo
export CORE_PEER_ADDRESS=peer0-ifinca:7051
peer chaincode upgrade -o orderer0-ifinca:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -v $VERSION -c '{"Args":[]}' -P "OR ('IfincaMSP.member')"