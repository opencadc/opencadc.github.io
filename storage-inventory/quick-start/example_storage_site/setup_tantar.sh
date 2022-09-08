#!/bin/bash

# Create a docker volume for data
#volume_created=$(docker volume ls | grep filedata | wc -l)
#if [[ ${volume_created} -eq 0 ]]; then
#  docker volume create --driver local --opt type=tmpfs --opt device=tmpfs --opt o=uid=1000,gid=1000 filedata
#fi


# Start tantar
docker run --detach -v $(pwd)/tantar/config:/config -v $(pwd)/filedata:/data --network inventory_network --name tantar --user opencadc:opencadc bucket.canfar.net/tantar:0.3-20220708T212025
