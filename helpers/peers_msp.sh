ORG_NAME=ifinca
MAINDIR=$HOME/organizations/peerOrganizations/$ORG_NAME
BASEPATH=$HOME/fabric-ca-client
BASECAPATH=$HOME/fabric-ca-client/ca
BASETLSCAPATH=$HOME/fabric-ca-client/tls-ca
DELAY=5

echo "MAINDIR: $MAINDIR"

sleep $DELAY

echo
echo "********** Generating the directories"
mkdir -p $MAINDIR
mkdir -p $MAINDIR/ca
mkdir -p $MAINDIR/msp $MAINDIR/msp/cacerts $MAINDIR/msp/tlscacerts
mkdir -p $MAINDIR/peers
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

for i in 0 1
do
PEERNAME="peer$i-$ORG_NAME"
echo
echo "#########################################################"
echo "********** Setting up the directories:"

PEERPATH=$MAINDIR/peers/$PEERNAME
mkdir -p $PEERPATH

echo "-- PEERPATH: $PEERPATH"

mkdir -p $PEERPATH/msp $PEERPATH/msp/signcerts $PEERPATH/msp/tlscacerts $PEERPATH/msp/cacerts $PEERPATH/msp/keystore
mkdir -p $PEERPATH/tls

sleep $DELAY

echo "********** Peers/tls"
cp $BASETLSCAPATH/peer$i-$ORG_NAME/msp/tlscacerts/*.pem $PEERPATH/tls/ca.crt
cp $BASETLSCAPATH/peer$i-$ORG_NAME/msp/signcerts/cert.pem $PEERPATH/tls/server.crt
cp $BASETLSCAPATH/peer$i-$ORG_NAME/msp/keystore/*_sk $PEERPATH/tls/server.key

sleep $DELAY

echo "********** Peers/msp"
cp $BASECAPATH/peer$i-$ORG_NAME/msp/signcerts/cert.pem $PEERPATH/msp/signcerts
cp $BASECAPATH/peer$i-$ORG_NAME/msp/keystore/*_sk $PEERPATH/msp/keystore/key.pem
cp $BASECAPATH/peer$i-$ORG_NAME/msp/cacerts/*.pem $PEERPATH/msp/cacerts/ca-cert.pem
cp $BASETLSCAPATH/peer$i-$ORG_NAME/msp/tlscacerts/*.pem $PEERPATH/msp/tlscacerts/tlsca-cert.pem
cp ./config/config.yaml $PEERPATH/msp/config.yaml

sleep $DELAY

done

echo
echo
echo
echo "Peer MSP generated successfully!"
echo "########################################################################"
echo