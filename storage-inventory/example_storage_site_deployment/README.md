# Example Storage Inventory Deployment 

## Introduction

### Assumptions in this document
- We're not deploying a production instance of the services -- examples presented here only show simple docker container deployments without orchestration (e.g. Docker Swarm, kubernetes).  
- There are dependencies on ancillary CADC services.  These depenedencies are necessary if the Storage Site being deployed is meant to be part of the CADC/CANFAR ecosystem, but not if this is meant to be an independent installation.  This document does not describe how to deploy those ancillary services.


## Requirements
- Single node with 
  - docker-ce (20.10 or newer)
  - docker-compose (docker-compose file version 2.4 or newer)
  - 2+ cores, 2GB RAM or more
  - enough disk space to accommodate any test data you want to store


## Example storage site 

Note: although not explicit in the example below, the CADC authentication services are still used and a valid CADC certificate is required where indicated.  

- Checkout this documentation from the github repo and, if necessary, copy the example_storage_site_deployment directory to where you want to run this example.
- Set up the database
  - Review and execute the `setup_database.sh` script.  This script will ensure that a consistent docker network is set up for this example site, modify postgres db configuration, and start a postgres container.
- Create a self-signed certificate for the proxy
  - Review and run the `setup_server_certificate.sh` script.  In production, this step will be replaced by using a server certificate from a trusted CA.
- Build the haproxy container image and start an instance
  - Building the image is necessary in this step in order to ensure that the version of haproxy being used supports [x509 proxy certificates](proxy/README.md).
  -  (Note: in order for the proxy to function with CADC certificates, the cadc pub CA will need to be provided...)
  - Review and run the `setup_proxy.sh` script.  Note that the container environment is started with `OPENSSL_ALLOW_PROXY_CERTS=1`
- Run the minoc service
  - Review the `setup_minoc.sh` script.  A key thing to note is that a local `filedata` directory is created and the uid/gid 8675309 is given write permissions.  This is because we're using the FileSystem storage adapter (see [minoc](minoc/README.md) notes for details) which requires that the account inside the minoc container (uid 8675309) be able to write files to the `filedata` directory.   
  - The service needs an x509 proxy certificate to run as.  Normally, this would be a priviliged user identity, but for this example you can use any CADC user's x509 proxy certificate.  If you have a CADC user account, you can download a proxy certificate and place the `cadcproxy.pem` file in the local `minoc/config` directory.
  - Also, although we're not using or setting up a global locator service ([raven](raven/README.md)), the service needs a valid certificate for accessing that service.  At this point, you can use the same proxy cert you're using in the step above: copy that file to `minoc/config/raven_rsa.pub`
  - run the `setup_minoc.sh` script
- Run the luskan service
  - Review the `setup_luskan.sh` script. As for the minoc service, a the user inside the container (id: 8675309) is given write permissions to a local directory.  This is for asynchronous queries.  We're not using those here, but the container will not run properly without a writable location.
  - As with the `minoc` service, the `luskan` service needs a valid x509 proxy certificate.  Use the same proxy as you used for the `minoc` service and copy that file to `luskan/config/cadcproxy.pem`
  - run the `setup_luskan.sh` script
- Upload a file to the storage site `curl -T TestFile1.fits -XPUT -E ~/.ssl/cadcproxy.pem -k "https://localhost:8443/minoc/files/test:TEST/TestFile1.fits"`
  - The `cadcproxy.pem` file is again a CADC x509 proxy certificate.  For this example, you can use the same proxy certificate you used above.
- Check that the file was uploaded successfully: `curl -E ~/.ssl/cadcproxy.pem -k "https://cyclops12:8443/luskan/sync?LANG=ADQL&QUERY=select+%2A+from+inventory.artifact&FORMAT=tsv"`.  Example output:
```
uri  uriBucket contentChecksum contentLastModified contentLength contentType contentEncoding lastModified  metaChecksum  id
test:TEST/TestFile1.fits  aa52c md5:38dcd67a352e70e9adfd22cb30477629  2022-07-20T19:57:50.946 5421      2022-07-25T19:57:50.964 md5:448b7ea3d716acc31daca10faa57baf6  9a9a09d5-466b-40f9-9874-6ef107e3d666
```
- Download the file `curl -o TestFile2.fits -E ~/.ssl/cadcproxy.pem -k "https://localhost:8443/minoc/files/test:TEST/TestFile1.fits"`


