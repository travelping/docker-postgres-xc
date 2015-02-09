#!/bin/bash
docker stop gtmm gtms
docker rm gtmm gtms

docker run --net=host --name=gtmm -itd umatomba/docker-postgres-xc /home/postgres/init_gtmm.sh "/postgres" "gtmm" "192.168.100.1"
sleep 30
docker run --net=host --name=gtms -itd umatomba/docker-postgres-xc /home/postgres/init_gtms.sh "/postgres" "gtms" "192.168.100.2"