#!/bin/sh

DOCKER_NS=${DOCKER_NS:-ibmblockchain}

IMAGES=$(docker images | grep ${DOCKER_NS} | awk '{print $1}')

mkdir -p /images/output/

for IMAGE in ${IMAGES}; do
	IMAGE_FILE="$(echo ${IMAGE} | cut -d "|" -f2 | tr -d \":\" | tr -d \"\/\" )"
	echo "Saving image ${IMAGE}"
	docker save ${IMAGE} -o /images/output/${IMAGE_FILE}
done
