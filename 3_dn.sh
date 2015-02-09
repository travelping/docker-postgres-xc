#!/bin/bash
docker stop d1 d2
docker rm d1 d2

docker run --net=host --name=d1 -itd umatomba/docker-postgres-xc /home/postgres/init_datanode.sh "/postgres" "d1" "192.168.100.5"
sleep 15
docker run --net=host --name=d2 -itd umatomba/docker-postgres-xc /home/postgres/init_datanode.sh "/postgres" "d2" "192.168.100.6"