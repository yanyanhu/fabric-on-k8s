# Deploy Fabric network on Kubernetes cluster

## Generate channel artifacts
```
$cd e2e_cli
$./generateArtifacts.sh
```

## Run Fabric network in single node kubernetes cluster

### Locate volumes into the kubernetes worker:
```
$mkdir -p /opt
$cp -r ./e2e_cli /opt/
```

### Run the network
```
$./start-fabric.sh
```

### Verify the network
Login to the test docker instance:
```
$docker ps -a | grep -i testenv
338d09730e05        bit-docker-local.artifactory.swg-devops.com/blue-audit/hyperledger-fabric-testenv@sha256:5dd1e28467c6b2827a8f7b450bfbd55ab3020d92bbf6a17b6837b42183503f38   "/bin/bash -c -- 'whi"   15 seconds ago      Up 14 seconds

$docker exec -it 338d09730e05 /bin/bash
```

Perform the e2e test:
```
$cd peer/
./scripts/init.sh
```
