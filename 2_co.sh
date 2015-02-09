#!/bin/bash
docker stop c1 c2
docker rm c1 c2

docker run --net=host --name=c1 -itd umatomba/docker-postgres-xc /home/postgres/init_coord.sh "/postgres" "c1" "192.168.100.3"
sleep 15
docker run --net=host --name=c2 -itd umatomba/docker-postgres-xc /home/postgres/init_coord.sh "/postgres" "c2" "192.168.100.4"