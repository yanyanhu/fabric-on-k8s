#!/bin/bash

DIR=`pwd`
source $DIR/scripts/init.sh
CHAINCODE_NAME=ccmarbles

installChaincode () {
	PEER=$1
	setGlobals $PEER
	peer chaincode install -n $CHAINCODE_NAME -v 1.0 -p githubx.com/hyperledger/fabric/examples/chaincode/go/marbles02 >&log.txt
	res=$?
	cat log.txt
        verifyResult $res "Chaincode installation on remote peer PEER$PEER has Failed"
	echo "===================== Chaincode is installed on remote peer PEER$PEER ===================== "
	echo
}

# $1 = peer number
instantiateChaincode () {
	PEER=$1
	setGlobals $PEER
	# while 'peer chaincode' command can get the orderer endpoint from the peer (if join was successful),
	# lets supply it directly as we know it using the "-o" option
	
	ARGS="{\"Args\":[\"\"]}"
	echo "$ARGS"
	if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
		peer chaincode instantiate -o $ORDERER_ADDRESS -C $CHANNEL_NAME -n $CHAINCODE_NAME -v 1.0  -c  "$ARGS" -P "OR	('Org1MSP.member','Org2MSP.member')" >&log.txt
	else
		peer chaincode instantiate -o $ORDERER_ADDRESS --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME -v 1.0 -c "$ARGS" -P "OR	('Org1MSP.member','Org2MSP.member')" >&log.txt
	fi
	res=$?
	cat log.txt
	verifyResult $res "Chaincode instantiation on PEER$PEER on channel '$CHANNEL_NAME' failed"
	echo "===================== Chaincode Instantiation on PEER$PEER on channel '$CHANNEL_NAME' is successful ===================== "
	echo

}

# $1 peer number; e.g. 0
# $2 = function name; queryMarblesByOwner
# $3 = param1
chaincodeQuery () {
  PEER=$1
  echo "===================== Querying on PEER$PEER on channel '$CHANNEL_NAME'... ===================== "
  setGlobals $PEER
  local rc=1
  local starttime=$(date +%s)

  ARGS="{\"Args\":[\"$2\",\"$3\"]}"
  echo "$ARGS"

  # continue to poll
  # we either get a successful response, or reach TIMEOUT
  echo "Attempting to Query PEER$PEER ..."
  peer chaincode query -C $CHANNEL_NAME -n $CHAINCODE_NAME -c "$ARGS" >&log.txt
  rc=$?
  cat log.txt
  if test $rc -eq 0 ; then
	echo "===================== Query on PEER$PEER on channel '$CHANNEL_NAME' is successful ===================== "
  else
	echo "!!!!!!!!!!!!!!! Query result on PEER$PEER is INVALID !!!!!!!!!!!!!!!!"
		echo "================== ERROR !!! FAILED to execute End-2-End Scenario =================="
	echo
	# exit 1
  fi
}

# $1 = peer number
# $2 = marble name, e.g. "marble1"
# $3 = color, e.g. "blue"
# $4 = value, e.g. 35
# $5 = person,"tom"
chaincodeInvoke () {
	PEER=$1
	setGlobals $PEER
	# while 'peer chaincode' command can get the orderer endpoint from the peer (if join was successful),
	# lets supply it directly as we know it using the "-o" option
	ARGS="{\"Args\":[\"initMarble\",\"$2\", \"$3\", \"$4\", \"$5\"]}"
	echo "$ARGS"
	if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
		peer chaincode invoke -o $ORDERER_ADDRESS -C $CHANNEL_NAME -n $CHAINCODE_NAME -v 1.0  -c "$ARGS" >&log.txt
	else
		peer chaincode invoke -o $ORDERER_ADDRESS --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME -c "$ARGS" >&log.txt
	fi
	res=$?
	cat log.txt
	verifyResult $res "Chaincode invoke on PEER$PEER on channel '$CHANNEL_NAME' failed"
	echo "===================== Chaincode Invoke on PEER$PEER on channel '$CHANNEL_NAME' is successful ===================== "
	echo
}

initChaincode () {
	## Install chaincode on Peer0/Org1 and Peer2/Org2
	echo "Installing chaincode on org1/peer0..."
	installChaincode 0
	echo "Install chaincode on org2/peer2..."
	installChaincode 2

	#Instantiate chaincode on Peer2/Org2
	echo "Instantiating chaincode on org2/peer2..."
	instantiateChaincode 2 
}

echo
echo "===================== All GOOD, End-2-End script initialization completed ===================== "
echo

echo
echo " _____   _   _   ____            _____   ____    _____ "
echo "| ____| | \ | | |  _ \          | ____| |___ \  | ____|"
echo "|  _|   |  \| | | | | |  _____  |  _|     __) | |  _|  "
echo "| |___  | |\  | | |_| | |_____| | |___   / __/  | |___ "
echo "|_____| |_| \_| |____/          |_____| |_____| |_____|"
echo

# exit 0
