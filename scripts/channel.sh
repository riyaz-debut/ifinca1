#!/bin/bash

#Create and join channel
export CHANNEL_NAME=mychannel
export ORDERER_CA=${PWD}/crypto/ordererOrganizations/ifinca/orderers/orderer0-ifinca/msp/tlscacerts/tlsca-cert.pem

echo
echo "Create the channel"
echo
peer channel create -o orderer0-ifinca:7050 -c $CHANNEL_NAME -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock ./${CHANNEL_NAME}.block --tls --cafile $ORDERER_CA

echo
echo "Join the channel peer 0"
echo
peer channel join -b ${CHANNEL_NAME}.block

echo
echo "Anchor peer update peer 0"
echo
peer channel update -o orderer0-ifinca:7050 -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls --cafile $ORDERER_CA

echo
echo "Join channel peer 1"
echo
export CORE_PEER_ADDRESS=peer1-ifinca:8051
peer channel join -b ${CHANNEL_NAME}.block
