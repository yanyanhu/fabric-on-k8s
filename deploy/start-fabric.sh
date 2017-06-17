#!/bin/bash


echo "====Start Fabric Network===="

# Create couchdb and offchaindb
echo "kubectl create -f fabric-couchdb.yaml"
kubectl create -f fabric-couchdb.yaml
echo "kubectl create -f fabric-offchaindb.yaml"
kubectl create -f fabric-offchaindb.yaml

# Create ca
echo "kubectl create -f fabric-ca-org1.yaml"
kubectl create -f fabric-ca-org1.yaml
echo "kubectl create -f fabric-ca-org2.yaml"
kubectl create -f fabric-ca-org2.yaml

# Create orderer
echo "kubectl create -f fabric-orderer.yaml"
kubectl create -f fabric-orderer.yaml

# TODO(YanyanHu):find better way to fix the dependency
# between couchdb and peer.
sleep 5

# Create peers
echo "kubectl create -f fabric-peer0-org1.yaml"
kubectl create -f fabric-peer0-org1.yaml
echo "kubectl create -f fabric-peer1-org1.yaml"
kubectl create -f fabric-peer1-org1.yaml
echo "kubectl create -f fabric-peer0-org2.yaml"
kubectl create -f fabric-peer0-org2.yaml
echo "kubectl create -f fabric-peer1-org2.yaml"
kubectl create -f fabric-peer1-org2.yaml

# Create test env
echo "kubectl create -f fabric-test.yaml"
kubectl create -f fabric-test.yaml

echo "====done===="
