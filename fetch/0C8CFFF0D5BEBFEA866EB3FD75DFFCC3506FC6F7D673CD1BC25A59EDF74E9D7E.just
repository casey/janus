set shell := ["bash","-c"]

package:
   docker run -it -v $(pwd):/go/src hyperledger/fabric-tools:2.0.0 peer lifecycle chaincode package ./src/transfer.tgz -l node -p ./src/transfer-contract/ --label transfer

network:
   ansible-playbook network.yml   