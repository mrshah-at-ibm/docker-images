#!/bin/sh
BASE_VER=0.4.6
FABRIC_VER=1.1.0
OS_TAG=alpine
ARCH=`uname -m`

mkdir -p ${GOPATH}/src/github.com/hyperledger
cd ${GOPATH}/src/github.com/hyperledger

# clone Fabric
git clone -b v${FABRIC_VER} https://github.com/hyperledger/fabric
cd fabric
find . -iname "*.sh" | xargs -I {} sed -i 's|/bin/bash|/bin/sh|g' {}
# build peer and orderer

echo -e "building fabric\n"
DOCKER_NS=ibmblockchain BASE_DOCKER_NS=ibmblockchain DOCKER_DYNAMIC_LINK=true make docker

#echo -e "building peer docker\n"
#DOCKER_NS=ibmblockchain BASE_DOCKER_NS=ibmblockchain DOCKER_DYNAMIC_LINK=true make peer-docker
#echo -e "building orderer docker\n"
#DOCKER_NS=ibmblockchain BASE_DOCKER_NS=ibmblockchain DOCKER_DYNAMIC_LINK=true make orderer-docker
# build fabric-ca

echo -e "building fabric-ca docker\n"
cd ..
git clone -b v${FABRIC_VER} https://github.com/hyperledger/fabric-ca
cd fabric-ca
# need to create hyperledger tag as fabric-ca does not have variabel in Dockerfile
sed -i 's|RUN .*apt-get.*||g' images/fabric-ca/Dockerfile.in
sed -i 's|hyperledger|ibmblockchain|g' images/fabric-ca/Dockerfile.in
#DOCKER_NS=ibmblockchain BASE_DOCKER_NS=ibmblockchain FABRIC_CA_DYNAMIC_LINK=true make docker-fabric-ca
DOCKER_NS=ibmblockchain BASE_DOCKER_NS=ibmblockchain FABRIC_CA_DYNAMIC_LINK=true make docker

# re-tag images
docker tag ibmblockchain/fabric-peer:${ARCH}-${FABRIC_VER} ibmblockchain/fabric-peer-${ARCH}:${OS_TAG}-${FABRIC_VER}
docker tag ibmblockchain/fabric-orderer:${ARCH}-${FABRIC_VER} ibmblockchain/fabric-orderer-${ARCH}:${OS_TAG}-${FABRIC_VER}
docker tag ibmblockchain/fabric-ccenv:${ARCH}-${FABRIC_VER} ibmblockchain/fabric-ccenv-${ARCH}:${OS_TAG}-${FABRIC_VER}
docker tag ibmblockchain/fabric-javaenv:${ARCH}-${FABRIC_VER} ibmblockchain/fabric-javaenv-${ARCH}:${OS_TAG}-${FABRIC_VER}
docker tag ibmblockchain/fabric-ca:${ARCH}-${FABRIC_VER} ibmblockchain/fabric-ca-${ARCH}:${OS_TAG}-${FABRIC_VER}
docker rmi ibmblockchain/fabric-baseimage:${ARCH}-${BASE_VER}
docker rmi ibmblockchain/fabric-baseos:${ARCH}-${BASE_VER}
docker rmi ibmblockchain/fabric-peer:${ARCH}-${FABRIC_VER}
docker rmi ibmblockchain/fabric-orderer:${ARCH}-${FABRIC_VER}
docker rmi ibmblockchain/fabric-ccenv:${ARCH}-${FABRIC_VER}
docker rmi ibmblockchain/fabric-javaenv:${ARCH}-${FABRIC_VER}
docker rmi ibmblockchain/fabric-ca:${ARCH}-${FABRIC_VER}
cd ../../
rm -Rf build
