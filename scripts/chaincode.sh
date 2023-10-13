#!/bin/bash

#Create and join channel
export CHANNEL_NAME=mychannel
export VERSION=1.0
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
peer chaincode instantiate -o orderer0-ifinca:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -v $VERSION -c '{"Args":[]}' -P "OR ('IfincaMSP.member')"

# peer chaincode upgrade -o orderer0.ifinca.co:7050 -C mychannel -n my_chaincode -v 1.1 -c '{"Args":[]}' -P "OR ('ifincaMSP.member')"
##################################### create order success ###############################
# peer chaincode invoke -o orderer0.ifinca.co:7050 --peerAddresses peer0.ifinca.co:7051 -C mychannel -n my_chaincode -c '{"function":"createOrder","Args":["{\"data_inputs\" : {\"mill_cost\" : 0,\"exporter_cost\" : 0,\"importer_cost\" : 0,\"roaster_cost\" : 0,\"cafe_cost\" : 0},\"order_id\" : \"IFIN-18856546\",\"order_no\" : \"IFIN-189\",\"quantity\" : 300,\"price\" : 400,\"ifinca_bonus\" : 200,\"cup_score\" : 100,\"country\" : \"New Zealand\",\"region\" : \"Antioquio\",\"process\" : \"Sun dried\",\"variety\" : \"Kent\",\"certificates\" : \"Organic\",\"base_unit\" : \"Sacks\",\"price_unit\" : \"Pesos\",\"qr_code\" : \"\",\"accepted_quantity\" : 0,\"elevation\" : \"\",\"delivery_date\" : 1557446400000,\"screen_size\" : \"\",\"major_defects\" : \"\",\"secondary_defects\" : \"\",\"moisture\" : \"\",\"farm\" : \"New Auckland Farms\",\"sample_request\" : \"Importer & Exporter\",\"importer_delivery_date\" : 1557619200000,\"exporter_delivery_date\" : 1557446400000,\"roaster_delivery_date\" : 1557705600000,\"cafe_delivery_date\" : 1557792000000,\"status\" : 0,\"cafe_stores\" : [ {\"name\" : \"Cafe 1\",\"country_code\" : \"57\",\"phone\" : \"441\",\"contact_name\" : \"Manager cafe 1\",\"status\" : 1,\"_id\" : \"5cde4dcf28fa4e90afd0ceb8\"}],\"roasters\" : [ {\"name\" : \"Roaster 1\",\"contact_name\" : \"Manager Roaster 1\",\"country_code\" : \"57\",\"phone\" : \"551\",\"status\" : 1,\"_id\" : \"5cde4e0328fa4e90afd0d029\"}],\"importers\" : [ {\"name\" : \"Importer 1\",\"contact_name\" : \"Manager Importer 1\",\"country_code\" : \"57\",\"phone\" : \"661\",\"status\" : 1,\"_id\" : \"5cde4f0a28fa4e90afd0d66c\"}]}"]}'
##################################### update order success ###############################
# peer chaincode invoke -o orderer0.ifinca.co:7050 -C mychannel -n my_chaincode -c '{"function":"updateOrder","Args":["{ \"order_no\": \"IFIN-189\" ,\"type\" :1,\"accepted_quantity\": 50, \"status\":1 }"]}'
