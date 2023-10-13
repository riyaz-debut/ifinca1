# Deploy the Ifinica Network

#### Download & Extract the Fabric CA bins to the server.
`wget https://github.com/hyperledger/fabric-ca/releases/download/v1.4.9/hyperledger-fabric-ca-linux-amd64-1.4.9.tar.gz`

#### Clone the repository.
`git clone https://sahil_goel@bitbucket.org/ifinca/ifinca-network.git`

#### Deploy the TLS CA and Orderer TLS CA:
`docker-compose -f ifinca-network/docker-compose-tlsca.yaml up -d`

`docker-compose -f ifinca-network/docker-compose-orderer-tlsca.yaml up -d`

#### Run the following commands to setup the Fabric CA Client:
`mkdir fabric-ca-client`

`cd fabric-ca-client/`

`cp fabric-samples/bin/fabric-ca-client ./`

`mkdir tls-ca tls-root-cert tls-ca-orderer tls-root-cert-orderer ca ca-orderer`

#### Copy the TLS ROOT Certs to the Client folder
`cp ~/ifinca-network/data/tlsca-ifinca/ca-cert.pem ./tls-root-cert/tls-ca-cert.pem`

`cp ~/ifinca-network/data/tlsca-orderer-ifinca/ca-cert.pem ./tls-root-cert-orderer/tls-ca-cert.pem`

#### TLS CA
###### Enroll TLS CA Admin
`export FABRIC_CA_CLIENT_HOME=$PWD`

`./fabric-ca-client enroll -d -u https://admin:8z61xdKp@0.0.0.0:7054 --csr.hosts '0.0.0.0' --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --mspdir tls-ca/admin/msp`

###### Register & Enroll CA Admin with TLS CA
`./fabric-ca-client register -d --id.name rcaadmin --id.secret 8z61xdKp -u https://0.0.0.0:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/admin/msp`

`./fabric-ca-client enroll -d -u https://rcaadmin:8z61xdKp@0.0.0.0:7054 --csr.hosts '0.0.0.0' --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --mspdir tls-ca/rcaadmin/msp`

###### Register & Enroll ORG Admin with TLS CA
`./fabric-ca-client register -d --id.name org-admin --id.secret 8z61xdKp -u https://0.0.0.0:7054 --id.type admin --id.attrs 'hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert' --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/admin/msp`

`./fabric-ca-client enroll -d -u https://org-admin:8z61xdKp@0.0.0.0:7054 --csr.hosts '0.0.0.0' --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --mspdir tls-ca/org-admin/msp`

#### Orderer TLS CA
###### Enroll TLS CA Admin
`./fabric-ca-client enroll -d -u https://admin:nqxudiHv@0.0.0.0:6054 --csr.hosts '0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --enrollment.profile tls --mspdir tls-ca-orderer/admin/msp`

###### Register & Enroll CA Admin with TLS CA
`./fabric-ca-client register -d --id.name rcaadmin --id.secret nqxudiHv -u https://0.0.0.0:6054 --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir tls-ca-orderer/admin/msp`

`./fabric-ca-client enroll -d -u https://rcaadmin:nqxudiHv@0.0.0.0:6054 --csr.hosts '0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --enrollment.profile tls --mspdir tls-ca-orderer/rcaadmin/msp`

###### Register & Enroll ORG Admin with TLS CA
`./fabric-ca-client register -d --id.name org-admin --id.secret nqxudiHv -u https://0.0.0.0:6054 --id.type admin --id.attrs 'hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir tls-ca-orderer/admin/msp`

`./fabric-ca-client enroll -d -u https://org-admin:nqxudiHv@0.0.0.0:6054 --csr.hosts '0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --enrollment.profile tls --mspdir tls-ca-orderer/org-admin/msp`

#### Copy Certs for the Org CA
`mkdir ~/ifinca-network/data/ca-ifinca/tls`

`cp ~/fabric-ca-client/tls-ca/rcaadmin/msp/signcerts/cert.pem 
~/ifinca-network/data/ca-ifinca/tls/`

`cp ~/fabric-ca-client/tls-ca/rcaadmin/msp/keystore/*_sk ~/ifinca-network/data/ca-ifinca/tls/key.pem`

#### Copy Certs for the Orderer Org CA
`mkdir ~/ifinca-network/data/ca-orderer-ifinca/tls`

`cp ~/fabric-ca-client/tls-ca-orderer/rcaadmin/msp/signcerts/cert.pem ~/ifinca-network/data/ca-orderer-ifinca/tls/`

`cp ~/fabric-ca-client/tls-ca-orderer/rcaadmin/msp/keystore/*_sk ~/ifinca-network/data/ca-orderer-ifinca/tls/key.pem`

#### Deploy the CA & Orderer CA
`docker-compose -f ~/ifinca-network/docker-compose-ca.yaml up -d`

`docker-compose -f ~/ifinca-network/docker-compose-orderer-ca.yaml up -d`

#### CA
###### Enroll CA Admin
`./fabric-ca-client enroll -d -u https://admin:oPj0GXnV@0.0.0.0:7066 --csr.hosts '0.0.0.0' --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir ca/admin/msp`

###### Register & Enroll Org Admin
`./fabric-ca-client register -d --id.name org-admin --id.secret oPj0GXnV --id.type admin --id.attrs 'hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert' -u https://0.0.0.0:7066 --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir ca/admin/msp`

`./fabric-ca-client enroll -d -u https://org-admin:oPj0GXnV@0.0.0.0:7066 --csr.hosts '0.0.0.0' --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir ca/org-admin/msp`

#### Orderer CA
###### Enroll Orderer CA Admin
`./fabric-ca-client enroll -d -u https://admin:KfuKYKGB@0.0.0.0:6066 --csr.hosts '0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir ca-orderer/admin/msp`

###### Register & Enroll Org Admin
`./fabric-ca-client register -d --id.name org-admin --id.secret KfuKYKGB --id.type admin --id.attrs 'hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert' -u https://0.0.0.0:6066 --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir ca-orderer/admin/msp`

`./fabric-ca-client enroll -d -u https://org-admin:KfuKYKGB@0.0.0.0:6066 --csr.hosts '0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir ca-orderer/org-admin/msp`

#### Register peers with TLS CA
`./fabric-ca-client register -d --id.name peer0-ifinca --id.secret PxzlgRUt --id.type peer -u https://0.0.0.0:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/admin/msp`

`./fabric-ca-client register -d --id.name peer1-ifinca --id.secret PxzlgRUt --id.type peer -u https://0.0.0.0:7054 --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/admin/msp`

#### Register peers with CA
`./fabric-ca-client register -d --id.name peer0-ifinca --id.secret PxzlgRUt --id.type peer -u https://0.0.0.0:7066 --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir ca/admin/msp`

`./fabric-ca-client register -d --id.name peer1-ifinca --id.secret PxzlgRUt --id.type peer -u https://0.0.0.0:7066 --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir ca/admin/msp`

#### Enroll peers with TLS CA
`./fabric-ca-client enroll -d -u https://peer0-ifinca:PxzlgRUt@0.0.0.0:7054 --enrollment.profile tls --csr.hosts 'peer0-ifinca,0.0.0.0' --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/peer0-ifinca/msp`

`./fabric-ca-client enroll -d -u https://peer1-ifinca:PxzlgRUt@0.0.0.0:7054 --enrollment.profile tls --csr.hosts 'peer1-ifinca,0.0.0.0' --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/peer1-ifinca/msp`

#### Enroll peers with CA
`./fabric-ca-client enroll -d -u https://peer0-ifinca:PxzlgRUt@0.0.0.0:7066 --csr.hosts 'peer0-ifinca,0.0.0.0' --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir ca/peer0-ifinca/msp`

`./fabric-ca-client enroll -d -u https://peer1-ifinca:PxzlgRUt@0.0.0.0:7066 --csr.hosts 'peer1-ifinca,0.0.0.0' --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir ca/peer1-ifinca/msp`

#### Register Orderer with Orderer TLS CA
`./fabric-ca-client register -d --id.name orderer0-ifinca --id.secret PxzlgRUt --id.type orderer -u https://0.0.0.0:6054 --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir tls-ca-orderer/admin/msp`

`./fabric-ca-client register -d --id.name orderer1-ifinca --id.secret PxzlgRUt --id.type orderer -u https://0.0.0.0:6054 --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir tls-ca-orderer/admin/msp`

`./fabric-ca-client register -d --id.name orderer2-ifinca --id.secret PxzlgRUt --id.type orderer -u https://0.0.0.0:6054 --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir tls-ca-orderer/admin/msp`

`./fabric-ca-client register -d --id.name orderer3-ifinca --id.secret PxzlgRUt --id.type orderer -u https://0.0.0.0:6054 --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir tls-ca-orderer/admin/msp`

`./fabric-ca-client register -d --id.name orderer4-ifinca --id.secret PxzlgRUt --id.type orderer -u https://0.0.0.0:6054 --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir tls-ca-orderer/admin/msp`

#### Register orderers with Orderer CA
`./fabric-ca-client register -d --id.name orderer0-ifinca --id.secret PxzlgRUt --id.type orderer -u https://0.0.0.0:6066 --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir ca-orderer/admin/msp`

`./fabric-ca-client register -d --id.name orderer1-ifinca --id.secret PxzlgRUt --id.type orderer -u https://0.0.0.0:6066 --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir ca-orderer/admin/msp`

`./fabric-ca-client register -d --id.name orderer2-ifinca --id.secret PxzlgRUt --id.type orderer -u https://0.0.0.0:6066 --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir ca-orderer/admin/msp`

`./fabric-ca-client register -d --id.name orderer3-ifinca --id.secret PxzlgRUt --id.type orderer -u https://0.0.0.0:6066 --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir ca-orderer/admin/msp`

`./fabric-ca-client register -d --id.name orderer4-ifinca --id.secret PxzlgRUt --id.type orderer -u https://0.0.0.0:6066 --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir ca-orderer/admin/msp`

#### Enroll orderers with Orderer TLS CA
`./fabric-ca-client enroll -d -u https://orderer0-ifinca:PxzlgRUt@0.0.0.0:6054 --enrollment.profile tls --csr.hosts 'orderer0-ifinca,0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir tls-ca-orderer/orderer0-ifinca/msp`

`./fabric-ca-client enroll -d -u https://orderer1-ifinca:PxzlgRUt@0.0.0.0:6054 --enrollment.profile tls --csr.hosts 'orderer1-ifinca,0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir tls-ca-orderer/orderer1-ifinca/msp`

`./fabric-ca-client enroll -d -u https://orderer2-ifinca:PxzlgRUt@0.0.0.0:6054 --enrollment.profile tls --csr.hosts 'orderer2-ifinca,0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir tls-ca-orderer/orderer2-ifinca/msp`

`./fabric-ca-client enroll -d -u https://orderer3-ifinca:PxzlgRUt@0.0.0.0:6054 --enrollment.profile tls --csr.hosts 'orderer3-ifinca,0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir tls-ca-orderer/orderer3-ifinca/msp`

`./fabric-ca-client enroll -d -u https://orderer4-ifinca:PxzlgRUt@0.0.0.0:6054 --enrollment.profile tls --csr.hosts 'orderer4-ifinca,0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir tls-ca-orderer/orderer4-ifinca/msp`

#### Enroll Orderer with Orderer CA
`./fabric-ca-client enroll -d -u https://orderer0-ifinca:PxzlgRUt@0.0.0.0:6066 --csr.hosts 'orderer0-ifinca,0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir ca-orderer/orderer0-ifinca/msp`

`./fabric-ca-client enroll -d -u https://orderer1-ifinca:PxzlgRUt@0.0.0.0:6066 --csr.hosts 'orderer1-ifinca,0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir ca-orderer/orderer1-ifinca/msp`

`./fabric-ca-client enroll -d -u https://orderer2-ifinca:PxzlgRUt@0.0.0.0:6066 --csr.hosts 'orderer2-ifinca,0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir ca-orderer/orderer2-ifinca/msp`

`./fabric-ca-client enroll -d -u https://orderer3-ifinca:PxzlgRUt@0.0.0.0:6066 --csr.hosts 'orderer3-ifinca,0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir ca-orderer/orderer3-ifinca/msp`

`./fabric-ca-client enroll -d -u https://orderer4-ifinca:PxzlgRUt@0.0.0.0:6066 --csr.hosts 'orderer4-ifinca,0.0.0.0' --tls.certfiles tls-root-cert-orderer/tls-ca-cert.pem --mspdir ca-orderer/orderer4-ifinca/msp`

#### Generating the MSP
`cd ifinca-network`

`./helpers/orderers_msp.sh`

`./helpers/peers_msp.sh`

#### Move the certificates to network directory
`mv ~/organizations/ ./`

#### Generate the channel artifacts
`./setup-network.sh`

#### Clone the chaincde at home directory
`cd ~`

`git clone https://sahil_goel@bitbucket.org/ifinca/ifinca-blockchain.git ifinca`

`cd ifinca`

`git checkout dev`

#### Deploy the peers, orderers and CLI
`cd ~/ifinca-network`

`docker-compose -f docker-compose-cli.yaml up -d`