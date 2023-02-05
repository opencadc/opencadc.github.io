#!/bin/bash

echo "*** Building haproxy image"
docker build -t haproxy-test haproxy

echo "*** Starting haproxy"
docker run --detach --rm  -e "OPENSSL_ALLOW_PROXY_CERTS=1" -v /dev/log:/dev/log -v $(pwd)/haproxy:/usr/local/etc/haproxy -v $(pwd)/cacerts:/usr/local/etc/cacerts -p 8443:8443 --network inventory_network  --name siserver haproxy-test
