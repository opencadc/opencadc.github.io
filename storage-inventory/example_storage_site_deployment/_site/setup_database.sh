#!/bin/bash

. ./ENVIRONMENT.sh

# Test if docker network has already been created.
# This is required during this test so that the containers can have predictable names and easily discoverable IPs
network_up=$(docker network ls | grep ${INVENTORY_NETWORK} | wc -l)
if [[ ${network_up} -eq 0 ]]; then
   docker network create --attachable ${INVENTORY_NETWORK}
fi

# In order for the service containers to contact the database, the pg_hba.conf file needs to be modifed.  This
# just discovers the subnet for the above docker network, and inserts that with a blanket 'trust' into the pg_hba.conf file
subnet=$(docker network inspect inventory_network | grep -i subnet | awk -F'"' '{print $4}')
if [ -e postgres/pg_hba.conf ]; then
  rm postgres/pg_hba.conf
fi
sed -e "sXDOCKERSUBNETX${subnet}X" postgres/pg_hba.conf.in > postgres/pg_hba.conf

# The storage inventory database needs to be set up with the correct users and passwords.  The si.dll file
# contains the postgres commands necessary to do this.  You will need to run these same commands, modified
# for the users and passwords you choose, in production.
if [ -e postgres/si.dl ]; then
  rm postgres/si.dll
fi
sed -e "s/TAPPASS/${TAPADM_PASSWORD}/" -e "s/TAPUPASS/${TAPUSER_PASSWORD}/" -e "s/INVPASS/${INVADM_PASSWORD}/" -e "s/XSIDBX/${INV_DB}/" postgres/si.dll.in > postgres/si.dll


# Create a docker volume for storing the PG data
# Test if the docker volume for the PG instance has already been created.
pg_volume_created=$(docker volume ls | grep ${PG_DATA_VOLUME} | wc -l)
if [[ ${pg_volume_created} -eq 0 ]]; then
# A docker volume will allow persistence of data between test runs, but the performance of such volumes
# is not sufficient for production.
  echo "*** Creating a local docker volume for the PG database.  This should NOT be used in a production setting."
  docker volume create  ${PG_DATA_VOLUME}
else
  echo "*** ${PG_DATA_VOLUME} already exists. This is OK."
fi

# Test if PG instance has already been initialized.  In a fresh installation, postgresql.conf is created at
# initialization.
docker run --rm  --volume pgdata:${PGHOME}/data postgres:12 su -l postgres -c "test -e ${PGHOME}/data/postgresql.conf"
if [ $? -eq 1 ];then
  echo "*** Initializing database.  In order to ensure correct sorting of certain fields, it is important to set the encoding, collate, and ctype during initialization."
  # At a minimum, the database needs to be initialized with the encoding, lc-locate, and lc-type set appropriately.
  # You may want to explore other options such as --data-checksum
  docker run --rm  --volume pgdata:${PGHOME}/data -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} ${PG_IMAGE} su -l postgres -c "${PG_INSTALL_DIR}/bin/initdb -D ${PGHOME}/data --encoding=UTF8 --lc-collate=C --lc-ctype=C >& /dev/null"
else
  echo "*** Database already initialized. This is OK."
fi


# Test if PG instance is already running.
pg_running=$(docker ps -f name=${PG_INSTANCE} | grep -v COMMAND | wc -l)
if [[ ${pg_running} -eq 0 ]]; then
  echo "*** Starting postgres."
  docker run --rm --network ${INVENTORY_NETWORK} --volume ${PG_DATA_VOLUME}:${PGHOME}/data -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} --detach --name ${PG_INSTANCE} ${PG_IMAGE} su -l postgres -c "${PG_INSTALL_DIR}/bin/postgres -D ${PGHOME}/data"
else
  echo "*** Postgres instance already running. This is probably OK."
fi

sleep 5

# Copy modified pg_hba.conf and si.dll to instance
docker cp postgres/pg_hba.conf ${PG_INSTANCE}:${PGHOME}/data/pg_hba.conf
docker cp postgres/si.dll ${PG_INSTANCE}:${PGHOME}/si.dll
docker exec ${PG_INSTANCE} su postgres -c "psql -f ${PGHOME}/si.dll -a"
docker exec ${PG_INSTANCE} su postgres -c "${PG_INSTALL_DIR}/bin/pg_ctl reload"
