#!/bin/bash
noneImages=$(docker images -a | grep "^<none>" | awk '{print $3}')
if [ ! -z "$noneImages" ]; then
    docker rmi -f $noneImages
fi
noneContainer=$(docker ps -a -f status=exited -q)
for file in $noneContainer; do
	docker container rm -f $file
done;
unset file;
