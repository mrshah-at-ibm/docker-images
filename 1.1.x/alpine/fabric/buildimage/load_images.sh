#!/bin/sh

for file in $(ls /images/input); do
	docker load -i /images/input/${file}
done

echo "Done loading images"
echo $(docker images)
