#!/bin/bash

# The file-system storage adapter needs a location to read and write files.  This location needs to be writeable by the
# user in the container that the service is running as -- the uid/gid is set to 8675309 in these images
if [[ ! -d filedata ]]; then
  mkdir filedata
  setfacl -m u:8675309:rwx filedata
  setfacl -m g:8675309:rwx filedata
fi

# Start minoc
docker run --detach  --rm -v $(pwd)/minoc/config:/config -v $(pwd)/cacerts:/config/cacerts -v $(pwd)/filedata:/data --network inventory_network --name minoc --user tomcat:tomcat bucket.canfar.net/minoc:0.7-20220620T171509
