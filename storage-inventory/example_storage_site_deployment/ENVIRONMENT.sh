#!/bin/bash

# Docker network to use.
INVENTORY_NETWORK=inventory_network

POSTGRES_PASSWORD=ThisIsASecret  # Set as the postgres user password.  don't use this in production.
TAPADM_PASSWORD=tapAdmPass0  # Change these in production
TAPUSER_PASSWORD=tapUserPass1
INVADM_PASSWORD=invAdmPass2

PG_INSTANCE=inventory_pg

# This is the name of the docker volume created for test data.  Docker volumes do not have sufficient performance for 
# a production setting.
PG_DATA_VOLUME=pgdata

PG_IMAGE=postgres:12  # This default will just use the latest PG 12 image from hub.docker.com.  Any basic PG image should work
PG_INSTALL_DIR=/usr/lib/postgresql/12  # In the default postgres:12 image, this is where the PG binaries are installed.
PGHOME=/var/lib/postgresql  # In the default postgres:12 image, this is the postgres user's home directory which is where much of the PG configuration information goes.

# Storage inventory db.  Tables are created by the services when they first initialize
INV_DB=storedb



