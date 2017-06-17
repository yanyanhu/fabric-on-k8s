# Deploy Fabric network on Kubernetes cluster

This is customized from e2e_cli example. You may follow the instructions below to generate channel-artifacts and crypto-config required for your network.


- Generate channel artifacts
```
cd e2e_cli
./generateArtifacts.sh
```

To run Fabric network in single node kubernetes cluster, follow the following steps:

- Locate volumes into the kubernetes worker:
```
mkdir -p /opt
cp -r ./e2e_cli /opt/
```

- Run the network
```
./start-fabric.sh
```
