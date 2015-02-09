#!/bin/bash

docker exec -it gtmm sudo -u postgres /usr/local/pgsql/bin/gtm_ctl status -Z gtm -D /postgres/gtmm/
docker exec -it gtms sudo -u postgres /usr/local/pgsql/bin/gtm_ctl status -Z gtm_standby -D /postgres/gtms/