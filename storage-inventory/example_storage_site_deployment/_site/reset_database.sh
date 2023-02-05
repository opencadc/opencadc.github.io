#!/bin/bash

. ./ENVIRONMENT.sh

docker kill ${PG_INSTANCE}

docker volume rm  ${PG_DATA_VOLUME}

rm postgres/si.dll postgres/pg_hba.conf
