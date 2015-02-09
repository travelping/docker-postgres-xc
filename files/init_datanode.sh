#!/bin/bash

# ./init_cd.sh "/postgres" "dn" "172.17.0.3"

function ERROR() {
        echo "$@"
        exit 1
}

[ -z $3 ] && ERROR "set param"

postgres_home=$1
nodename=$2
ip=$3

echo -e "192.168.100.1    gtmm\n192.168.100.2    gtms\n192.168.100.3    c1\n192.168.100.4    c2\n192.168.100.5    d1\n192.168.100.6    d2" >> /etc/hosts

cd $postgres_home

sudo -u postgres /usr/local/pgsql/bin/initdb -D $nodename --nodename $nodename

sudo -u postgres cp /home/postgres/postgresql.conf "$postgres_home/$nodename"
sudo -u postgres cp /home/postgres/pg_hba.conf "$postgres_home/$nodename"

sudo -u postgres sed -i "s/^#listen_addresses =.*/listen_addresses = '$ip'/" "$postgres_home/$nodename/postgresql.conf"
sudo -u postgres sed -i "s/^#gtm_host =.*/gtm_host = 'gtmm'/" "$postgres_home/$nodename/postgresql.conf"
sudo -u postgres sed -i "s/^#gtm_port =.*/gtm_port = 6666/" "$postgres_home/$nodename/postgresql.conf"
sudo -u postgres sed -i "s/^#pgxc_node_name =.*/pgxc_node_name = '$nodename'/" "$postgres_home/$nodename/postgresql.conf"

sudo -u postgres /usr/local/pgsql/bin/pg_ctl start -D "$postgres_home/$nodename" -Z datanode -l "$postgres_home/log/$nodename.log"
psql postgres -h c1 -U postgres -c "CREATE NODE $nodename WITH (TYPE='datanode', PORT=5432);"
psql postgres -h c1 -U postgres -c "select pgxc_pool_reload();"
sleep 10
tail -f  "$postgres_home/log/$nodename.log"