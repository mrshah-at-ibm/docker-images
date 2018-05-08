#!/bin/sh

dockerd-entrypoint.sh &

sleep 2
load_images.sh
build.sh
save_images.sh

