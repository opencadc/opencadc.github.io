#!/bin/bash

. ./ENVIRONMENT.sh

. ./CA.sh

/usr/bin/openssl req -new -sha256 -nodes -out cadir/server.csr -newkey rsa:2048 -keyout cadir/server.key -config <( cat cadir/server.csr.cnf )

/usr/bin/openssl x509 -req -in cadir/server.csr -CA cadir/ca.crt  -CAkey cadir/ca.key -CAcreateserial -out cadir/server.crt -days 10 -sha256 -extfile cadir/v3.ext

cat cadir/server.crt cadir/server.key > cadir/server.pem

cp cadir/server.pem haproxy/
