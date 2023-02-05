#!/bin/bash

# Asynchronous queries need a place to write results.  This location needs to be writeable by the
# user in the container that the service is running as -- the uid/gid is set to 8675309 in these images
if [[ ! -d asyncdata ]]; then
  mkdir asyncdata
  setfacl -m u:8675309:rwx asyncdata
  setfacl -m g:8675309:rwx asyncdata
fi

docker run --detach --rm -v $(pwd)/luskan/config:/config -v $(pwd)/cacerts:/config/cacerts -v $(pwd}/asyncdata:/data --network inventory_network --name luskan --user tomcat:tomcat bucket.canfar.net/luskan:0.4-20220712T205031
