# Storage Inventory Deployment Quick Start

## Introduction
This document is meant to guide you through a simple deployment of Storage Inventory site services and applications and  to introduce some of the concepts required.  Please also look at the development documentation -- [opencadc/storage-inventory](https://github.com/opencadc/storage-inventory), especially the [architecture description](https://github.com/opencadc/storage-inventory/tree/master/storage-inventory-dm).

### Assumptions in this document
- We're not deploying a production instance of the services -- examples presented here only show simple docker container deployments without orchestration (e.g. Docker Swarm, kubernetes).  
- There are dependencies on ancillary CADC services.  These depenedencies are necessary if the Storage Site being deployed is meant to be part of the CADC/CANFAR ecosystem, but not if this is meant to be an independent installation.  This document does not describe how to deploy those ancillary services.

## Basic Concepts
### Storage site vs Global site
- a _Storage site_ maintains an inventory of and provides access to the files stored at a particular location.  If you have files in multiple data centres, or more than one storage platform in one data centre (e.g. some files on a posix file-system and some on Ceph object storage), you would have more than one _Storage site_.  

  A _Storage site_ runs two services:
  - [`minoc`](minoc/README.md) - file service. Provides a file upload and download service.  
  - [`luskan`](luskan/README.md) - metadata query service. Provides a service for querying the inventory database using the TAP protocol.  
  
  A _Storage site_ will also need to run applications to validate the inventory contents:
  - [`tantar`](tantar/README.md) - file validation.  This compares the artifact metadata in the inventory database with the actual storage, ensuring that they are in sync.  
  
  Additional applications will be needed if the _Storage site_ is meant to be synced with other _Storage sites_, which will also require a _Global site_ to be deployed.
  - `fenwick` - incremental metadata synchronization between the _Storage site_ and _Global site_.  Only compares artifacts since the last run.  
  - `ratik` - full metadata validation between the _Storage site_ and _Global site_.
  - `ringhold` - metadata validation after a site policy change.  Subtle difference with above.
  - `critwall` - file synchronization.  If metadata synchronization (`fenwick`, `ratik`) results in aritfacts at a site without the associated files, critwall will negotiate the file transfers with the _Global site raven_ service.

- a _Global site_ maintains a view of the inventory of all configured _Storage sites_.  _Storage sites_ do not know about other _Storage sites_: if two _Storage sites_ are meant to be kept in sync, they will query the _Global site_ for files that they are missing.
  
  A _Global site_ runs three services:
  - `raven` - file transfer negotiation.  A request for a file through `raven` will not deliver the bytes of the file, but rather a redirect to the `minoc` service at a _Storage site_ that has the requested file.
  - `luskan` - inventory database query.  Same service as for the _Storage sites_, but for the global inventory.
  - [`baldur`](baldur/README.md) - file access authorization based on file namespace and authorization groups.  Not really a _Global site_ service, more like one of the ancillary services mentioned above.
    - If you only plan to have a single _Storage site_, and have no need of a _Global site_, you'll still need to deploy `baldur` if you want to grant authorization for users to upload or retrieve files.

### Artifact vs file
- an artifact is the entire body of metadata describing a data file.

### Site vs inventory
- yeah, sorry, these terms are often used interchangeably. Stirctly speaking, though, inventory should refer to the artifacts in the inventory database. (_Storage site_ == _Storage Inventory_; _Global site_ == _Global inventory_)  




## Requirements
- Processing node requirements (where services and applications run)
  - docker-ce (20.10 or newer)
  - docker-compose (docker-compose file version 2.4 or newer)
  - haveged (or other entropy-generating service)
    - this is only necessary on hosts running the services.
  - _Storage Inventory_ services and applications don't consume a lot of memory (~1GB-4GB per instance) although some (minoc, tantar, critwall) are multithreaded and can take advantage of multiple cores.
  - In a production setting it would be best not to mix services and applications on the same nodes in order to ensure that service quality isn't affected by things like metadata validation.  A single node might suffice in a test deployment whereas you'll need several nodes for a production deployment.
- Database requirements
  - PG 12.3 or newer
  - storage: about 1KB/artifact (storage site) or 1.5KB/artifact (global site) for data and indices.
  - RAM/CPU:  For a site with 200 million artifacts, 20 cores with 180GB RAM and NVMe storage gives sufficient performance.


## General configuration notes
- services and applications expect all configuration files and credentials to be available in the container instance below the directory `/config`.
- config files are plain-text key-value files, with the key usually being of the form `org.opencadc.serviceName.keyName`
- configuration descriptions are provided on GitHub [opencadc/storage-inventory](https://github.com/opencadc/storage-inventory), with more detail in the sections in this document.

## A word about credentials
Services and applications use x509 proxy certificates for authorization and authentication.  
- *Applications* (critwall, fenwick, ratik, ringhold, tantar) will require credentials for a user that has
  been granted permissions to access files by a grant provider (e.g. baldur). This user doesn't make privileged calls and has no access to the actual storage or to other credentials.
- *Services* (baldur, luskan, minoc, raven) will require credentials that allow privileged operations on behalf of a user (e.g. minoc checking baldur if a particular user is allowed to download a file, baldur checking group membership against a group management service). Currently, this privileged account is one that needs to be recognized by the CADC services.
- services and applications both expect the above credentials to be provided as an x509 proxy certificate presented in the container instance as `/config/cadcproxy.pem`.  

## Example storage site 

Note: although not explicit in the example below, the CADC authentication services are still used and a valid CADC certificate is required where indicated.  

- Checkout this documentation from the github repo and, if necessary, copy the example_storage_site directory to where you want to run this example.
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



# Common problems


- I'm sure that my service/application is configured with the correct inventory database url/username/password but it is failing to initialize.
  - check that the database `pg_hba.conf` file allows connections from the host that you're running the service on.  If you're running services in a docker swarm or a kubernetes cluster, the egress IP might not be obvious.
  - in the service configuration files, check that the configuration keys are correct.  For example, the key for the database url for the application `fenwick` is `org.opencadc.fenwick.inventory.url`; the key for the database url for the service `minoc` is `org.opencadc.minoc.inventory.url`.  It is easy to cut and paste between config files and forget to change the key.
