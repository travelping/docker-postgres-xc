#!/bin/bash

# ./init_gtm.sh "/postgres" "gtm" "mode"

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

sudo -u postgres /usr/local/pgsql/bin/initgtm -Z gtm -D "$postgres_home/$nodename"
sudo -u postgres cp /home/postgres/pg_hba.conf "$postgres_home/$nodename"
sudo -u postgres cp /home/postgres/gtm.conf "$postgres_home/$nodename"

sudo -u postgres sed -i "s/^#listen_addresses =.*/listen_addresses = '$ip'/" "$postgres_home/$nodename/gtm.conf"
sudo -u postgres sed -i "s/^#nodename =.*/nodename = 'gtms'/" "$postgres_home/$nodename/gtm.conf"
sudo -u postgres sed -i "s/^#startup =.*/startup = STANDBY/" "$postgres_home/$nodename/gtm.conf"
sudo -u postgres sed -i "s/^#active_host =.*/active_host = 'gtmm'/" "$postgres_home/$nodename/gtm.conf"
sudo -u postgres sed -i "s/^#active_port =.*/active_port = 6666/" "$postgres_home/$nodename/gtm.conf"

sudo -u postgres /usr/local/pgsql/bin/gtm_ctl start -D "$postgres_home/$nodename" -Z gtm_standby -l "$postgres_home/log/$nodename.log"
sleep 10
tail -f "$postgres_home/log/$nodename.log"