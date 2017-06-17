#!/bin/bash


kubectl create -f fabric-couchdb.yaml
kubectl create -f fabric-offchaindb.yaml

sleep 5

kubectl create -f fabric-ca-org1.yaml
kubectl create -f fabric-ca-org2.yaml

sleep 3

kubectl create -f fabric-orderer.yaml

sleep 3

kubectl create -f fabric-peer0-org1.yaml
kubectl create -f fabric-peer1-org1.yaml
kubectl create -f fabric-peer0-org2.yaml
kubectl create -f fabric-peer1-org2.yaml

sleep 3

kubectl create -f fabric-test.yaml

echo "====done===="
