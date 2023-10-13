ORG_NAME=ifinca
MAINDIR=$HOME/organizations/ordererOrganizations/$ORG_NAME
BASEPATH=$HOME/fabric-ca-client
BASECAPATH=$HOME/fabric-ca-client/ca-orderer
BASETLSCAPATH=$HOME/fabric-ca-client/tls-ca-orderer
DELAY=5

mkdir -p $MAINDIR
mkdir -p $MAINDIR/ca
mkdir -p $MAINDIR/msp $MAINDIR/msp/cacerts $MAINDIR/msp/tlscacerts
mkdir -p $MAINDIR/orderers
mkdir -p $MAINDIR/tlsca
mkdir -p $MAINDIR/users/admin/msp $MAINDIR/users/admin/tls $MAINDIR/users/admin/msp/cacerts $MAINDIR/users/admin/msp/tlscacerts $MAINDIR/users/admin/msp/keystore $MAINDIR/users/admin/msp/signcerts

sleep $DELAY

echo "--- Copying files at CA:"
cp $BASECAPATH/org-admin/msp/signcerts/cert.pem $MAINDIR/ca/ca-cert.pem
cp $BASECAPATH/org-admin/msp/keystore/*_sk $MAINDIR/ca/key.pem

sleep $DELAY

echo "--- Copying files at TLSCA:"
cp $BASETLSCAPATH/org-admin/msp/signcerts/cert.pem $MAINDIR/tlsca/tlsca-cert.pem
cp $BASETLSCAPATH/org-admin/msp/keystore/*_sk $MAINDIR/tlsca/key.pem

sleep $DELAY

echo "--- Copying files at MSP:"
cp $BASECAPATH/admin/msp/cacerts/*.pem $MAINDIR/msp/cacerts/ca-cert.pem
cp $BASETLSCAPATH/admin/msp/tlscacerts/*.pem $MAINDIR/msp/tlscacerts/tlsca-cert.pem
cp ./config/config.yaml $MAINDIR/msp/config.yaml

sleep $DELAY

echo "--- Copying files at AdminMSP:"
cp $BASECAPATH/org-admin/msp/cacerts/*.pem $MAINDIR/users/admin/msp/cacerts/ca-cert.pem
cp $BASECAPATH/org-admin/msp/signcerts/cert.pem $MAINDIR/users/admin/msp/signcerts/cert.pem
cp $BASECAPATH/org-admin/msp/keystore/*_sk $MAINDIR/users/admin/msp/keystore/key.pem
cp $BASETLSCAPATH/org-admin/msp/tlscacerts/*.pem $MAINDIR/users/admin/msp/tlscacerts/tlsca-cert.pem
cp ./config/config.yaml $MAINDIR/users/admin/msp/config.yaml

cp $BASETLSCAPATH/org-admin/msp/tlscacerts/*.pem $MAINDIR/users/admin/tls/ca.crt
cp $BASETLSCAPATH/org-admin/msp/signcerts/cert.pem $MAINDIR/users/admin/tls/server.crt
cp $BASETLSCAPATH/org-admin/msp/keystore/*_sk $MAINDIR/users/admin/tls/server.key

sleep $DELAY

for i in 0 1 2 3 4
do
echo
echo "#########################################################"
echo "********** Setting up the directories:"

ORDERERPATH=$MAINDIR/orderers/orderer$i-$ORG_NAME

mkdir -p $ORDERERPATH
echo "-- ORDERERPATH: $ORDERERPATH"

mkdir $ORDERERPATH/msp $ORDERERPATH/msp/cacerts $ORDERERPATH/msp/keystore $ORDERERPATH/msp/signcerts $ORDERERPATH/msp/tlscacerts  
mkdir $ORDERERPATH/tls

echo "--- Copying files at TLS:"
cp $BASETLSCAPATH/orderer$i-$ORG_NAME/msp/tlscacerts/*.pem $ORDERERPATH/tls/ca.crt
cp $BASETLSCAPATH/orderer$i-$ORG_NAME/msp/signcerts/cert.pem $ORDERERPATH/tls/server.crt
cp $BASETLSCAPATH/orderer$i-$ORG_NAME/msp/keystore/*_sk $ORDERERPATH/tls/server.key

sleep $DELAY

echo "********** Orderer/msp"
cp $BASECAPATH/orderer$i-$ORG_NAME/msp/signcerts/cert.pem $ORDERERPATH/msp/signcerts
cp $BASECAPATH/orderer$i-$ORG_NAME/msp/keystore/*_sk $ORDERERPATH/msp/keystore/key.pem
cp $BASECAPATH/orderer$i-$ORG_NAME/msp/cacerts/*.pem $ORDERERPATH/msp/cacerts/ca-cert.pem
cp $BASETLSCAPATH/orderer$i-$ORG_NAME/msp/tlscacerts/*.pem $ORDERERPATH/msp/tlscacerts/tlsca-cert.pem
cp ./config/config.yaml $ORDERERPATH/msp/config.yaml

sleep $DELAY

done

echo
echo
echo
echo "Orderer MSP generated successfully!"
echo "########################################################################"
echo