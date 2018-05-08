#!/bin/bash
BASE_VER=0.4.6
FABRIC_VER=1.1.0
OS_TAG=alpine
ARCH=`uname -m`

# build baseimage and baseos
echo -e "building ibmblockchain/fabric-baseimage:${OS_TAG}-${BASE_VER}\n"
docker build -t ibmblockchain/fabric-baseimage:${OS_TAG}-${BASE_VER} fabric-baseimage
docker tag ibmblockchain/fabric-baseimage:${OS_TAG}-${BASE_VER} ibmblockchain/fabric-baseimage:${ARCH}-${BASE_VER}

echo -e "building ibmblockchain/fabric-baseos:${OS_TAG}-${BASE_VER}\n"
docker build -t ibmblockchain/fabric-baseos:${OS_TAG}-${BASE_VER} fabric-baseos
docker tag ibmblockchain/fabric-baseos:${OS_TAG}-${BASE_VER} ibmblockchain/fabric-baseos:${ARCH}-${BASE_VER}

echo -e "building intermediate build image\n"
docker build -t buildimage fabric/buildimage

echo -e "saving base images to be able to mount inside buildimage"
docker save ibmblockchain/fabric-baseos:${ARCH}-${BASE_VER} -o fabric/images/input/ibmblockchain-fabric-baseos
docker save ibmblockchain/fabric-baseimage:${ARCH}-${BASE_VER} -o fabric/images/input/ibmblockchain-fabric-baseimage

echo -e "building all of fabric"
docker run -ti -v ${PWD}/fabric/images:/images --privileged buildimage
