

# CADC Storage Inventory Architecture and Deployment


Read the entire document or jump to a relevant section below.


### Table of Contents

1. [Introduction](#introduction)
    * [Key Storage Inventory Terms and Concepts](#key-storage-inventory-terms-and-concepts)
    * [Storage Inventory Resources](#storage-inventory-resources)
1. [Overview of a Storage Site](#overview-of-a-storage-site)
    * [System Architecture](#system-architecture)
    * [Standalone Storage Site](#standalone-storage-site)
1. [Client Software](#client-software)
1. [Deployment Prerequisites](#deployment-prerequisites)
    * [Hardware Requirements](#hardware-requirements)
    * [Software Requirements](#software-requirements)
1. [Deployment](#deployment)
1. [Healthchecks and Monitoring](#healthchecks-and-monitoring)    
1. [FAQ](#faq)


## Introduction

### Key Storage Inventory Terms and Concepts

- _Artifact_: a representation of a file and its metadata in SI. The terms _file_ and _artifact_ are often used interchangeably through the document.
- _bucket_: Analogous to an S3 bucket or a folder, but specifically referring to the Storage Inventory implmentation. Buckets are created on storage (on a POSIX file-system, these would be just directories) and artifacts are distributed among these.  SI applications can be configured to work on subsets of buckets. 
- _collection_: A _collection_ is a set of artifacts/files/observations that form a logical group in your system.  For example, for a multi-mission data centre like the CADC, collections are often the set of all data from a telescope.  A collection could also be all artifacts/files that compose a special data release for a single telescope (e.g. 'DR1').  The terms _collection_ and _namespace_ are often used interchangeably, but _namespace_ has a key role in defining artifact metadata.
- _namespace_: A _namespace_ is the SI identifier for a _collection_ -- this namespace becomes part of artifact's unique metadata: the URI for an artifact is '_namespace/filepath_'.  A namespace can be any unique name in SI (**Pat - any restrictions?**), e.g. 'ska:askap', 'cadc:CFHT'.  The _filepath_ could be just a file name (e.g. test1.fits) or a relative path (e.g. proc1/test1.fits).
- _resourceID/serviceID_: Unique ID in a URI form associated with a deployed service. A registry service provides a look-up to translate these IDs into service URLs.  Example: `ivo://opencadc.org/minoc`

### Storage Inventory Resources
- Container image repository: https://images.opencadc.org
    - This is an OCI compliant image repository, so images can be downloaded using the standard URL format: `https://images.opencadc.org/<project>/<image>:<tag>`, where the list of projects, images, and tags can be found using the commands below.  Most Storage Inventory images will be found in the `storage-inventory` project, although images for supporting services may be in other projects (i.e. `core`).
    - To see what projects are hosted here, use ([`jq`](https://stedolan.github.io/jq/) is a helpful command for parsing JSON): 

        `curl -s https://images.opencadc.org/api/v2.0/projects | jq '[.[].name] | sort'`

    - To see what images are available in a project, use (e.g., for storage-inventory): 

        `curl -s https://images.opencadc.org/api/v2.0/projects/storage-inventory/repositories | jq '[.[].name] | sort'`

    - To see what version tags are available for an image, use (e.g., for storage-inventory/minoc):

        `curl -s https://images.opencadc.org/api/v2.0/projects/storage-inventory/repositories/minoc/artifacts | jq '[.[].tags | select (. != null) | .[].name] | sort'`

- A note on image tags: 
    - image tags will look like _version_ (e.g. `0.9.0`) or _version-datetimestamp_ (e.g. `0.9.0-20230217T201656`)  
    - The datetimestamp is a build identifier -- the image with the a plain version number (0.9.0 in the example given) will be the same image as the image with the _same version number and the **latest** build identifier_.
    - for a version of `x.y.z`:
        - `x` will change with major releases -- functionality, api, and configuration may change and break earlier configuration.
        - `y` will change with minor releases -- minor non-breaking or backwards-compatible feature or configuration changes.
        - `z` will change with minor bug fixes -- otherwise compatible with current version features and configuration.
    - More documents can be found on the [opencadc github pages](https://github.com/opencadc/storage-inventory)



## Overview of a Storage Site

### System Architecture
The Storage Inventory consists of the components that make up one or more Storage sites and a Global site.  A Storage site can exist on its own, as a mechanism for maintaining a structured inventory of files.  Below, we will describe a single Storage site (Global site to follow). A detailed description of the data model, features and limitations can be found [here](https://github.com/opencadc/storage-inventory/tree/master/docs).

<center>
<img src="Architecture.drawio.png" width="500">
</center>


#### Standalone Storage Site
(What are the differences between this and a 'full' storage site deployment?  GMS? A&A?)

A Storage site maintains an inventory of the files stored at a particular location, and provides mechanisms to access (**minoc**) those files and query (**luskan**) the local inventory. 
Below is an outline of the deployment for a Storage Inventory Storage site, with one storage system, one database, etc, in one data centre. If you have files in multiple data centres, or more than one storage platform in one data centre (e.g. some files on a posix file-system and some on Ceph object storage), you would 
have more than one Storage site, and each site would run its own services, database, storage, and applications.

<center>
<img src="SingleSiteWithExternal.drawio.png" width="500">
</center>

A Storage Inventory Storage site consists of following:
- Front-end Web services:
    - [`minoc`](https://github.com/opencadc/storage-inventory/tree/master/minoc): REST based file service that supports HEAD, GET, PUT, POST, DELETE operations.
    - [`luskan`](https://github.com/opencadc/storage-inventory/tree/master/luskan): Web Service used to query artifact metadata using the [`IVOA Table Access Protocol`](https://www.ivoa.net/documents/TAP/) (Replace TAP link with user document, not reference to spec....)
- Resources:
    - **Inventory database**: this is the ledger tracking all the files storage at the site. Applications and services will access this database in parallel so it will need to have good performance, especially as the content as the site grows.  Currently only Postgresql is supported.
    - **Storage platform**: the actual back-end storage platform. Currently, SI supports two platforms: [POSIX filesystem](https://github.com/opencadc/storage-inventory/tree/master/cadc-storage-adapter-fs) and the [Swift Object Store API](https://github.com/opencadc/storage-inventory/tree/master/cadc-storage-adapter-swift) (e.g. CEPH Object Store)
- Applications that run at a storage site:
    - [`tantar`](https://github.com/opencadc/storage-inventory/tree/master/tantar): artifact-validate application that compares the inventory database against the back-end storage.
    - [`ringhold`](https://github.com/opencadc/storage-inventory/tree/master/ringhold): artifact removal applications.  Use with caution: essentially the same as `\rm -r` on a _namespace_.
- Supporting Infrastructure and Services
    - **proxy/ingress**: All the calls the front-end Web services need to go through a proxy/ingress that provides SSL termination and ensures that authentication headers are correctly set before being routed to the actual service. The proxy needs a public IP address and a valid SSl certificate (e.g. [Let's Encrypt](https://www.letsencrypt.org)).  This proxy service might be an external load balancer (e.g. [haproxy](www.haproxy.org)) or an ingress in your container orchestration system -- the details will vary depending on your deployment environment.  Whichever proxy or ingress is chosen, it must support x509 client proxy certificates.
        - Note: although the diagram above shows a separate proxy for Storage site services and supporting services, this might not be necessary on all infrastructure.
    - [`registry`](https://github.com/opencadc/reg/tree/master/cadc-registry-server): Used to map serviceIDs and resourceIDs to the actual URLs where the service is deployed.  Client software, services, and applications will use a registry to look up the locations of services. 
    - [`baldur`](https://github.com/opencadc/storage-inventory/tree/master/baldur): permissions service which uses configurable rules to grant access based on resource identifiers (_Artifact.uri_ values in the [inventory data model](https://github.com/opencadc/storage-inventory/tree/master/storage-inventory-dm)).
    This service is required if Authentication and Authorization (A&A) is required for the SI deployment. Generally, **baldur** works along with a Group Management Service (GMS) and/or User Service.
     
## Client Software
Generic HTTP client tools such as [`curl`](https://curl.se) or [`wget`](https://www.gnu.org/software/wget/) can be used to interact with the SI, however multi-step operations such as transfer negotiations or transfer of large files with
SI transactions might require dedicated scripts.  (TODO provide examples of usage)

Alternatively, the CADC maintains Python client applications/libraries that can be used with the SI:
- [`cadcdata`](https://pypi.org/project/cadcdata/) - for file operations with **minoc** and **raven**. That includes transfer negotiations, file uploads, downloads or deletes. Or simply file information. The package takes advantage of
     the SI features to offer robust and fault tollerant transfer of files small or large.
- [`cadctap`](https://pypi.org/project/cadctap/) - for querying the artifact metadata. It works with a **luskan** service delopyed at a site or the global one. Alternatively, any generic TAP-based tool can be used to query **luskan** including (but not limitted to) [`PyVO`](https://pypi.org/project/pyvo/)

The [`CADC Direct Data Service`](https://www.cadc-ccda.hia-iha.nrc-cnrc.gc.ca/en/doc/data/) presents a variety of scenarios for accessing the CADC SI using generic and specific client tools. 


## Deployment Prerequisites

### Hardware Requirements
Database:
- storage: about 1KB/artifact (storage site) or 1.5KB/artifact (global site) for data and indices.
- RAM/CPU: For a site with 200 million artifacts, 20 cores with 180GB RAM and NVMe storage gives sufficient performance.
- PG 12.3 or newer 

Storage platform:
- Ceph Object store (version 14 or greater), **or**
- POSIX file-system.  

Worker nodes:
- SI applications and services don't consume a lot of memory (~1GB-4GB per instance) although some (minoc, tantar, critwall) are multithreaded and can take advantage of multiple cores.
- In a production setting it would be best not to mix services and applications on the same nodes in order to ensure that service quality isn't affected by things like metadata validation. A single node might suffice in a test deployment whereas you'll need several nodes for a production deployment.

### Software Requirements

- container images are all OCI-compliant (produced with docker cli), so should run in any compatible environment.
- orchestration software: A simple, single node test deployment example will be provided.  Deployment within different orchestration environments (e.g. Docker Swarm, Kubernetes) are beyond the scope of this document (maybe we can provide helm charts eventually...?)
- [`haveged`](https://www.issihosts.com/haveged/) (or other entropy-generating service) this is only necessary on hosts running the services. 
     

## Deployment 

Note on logging: Storage inventory services and application containers all log to `stdout` by default -- for a production deployment, these should be captured and preserved by whatever mechanism is available on your system.

1. **Storage**

    - How to configure your storage is dependent upon your local hardware and data centre details.  However -- 
        - There are two types of storage supported:
            - [POSIX filesystem](https://github.com/opencadc/storage-inventory/tree/master/cadc-storage-adapter-fs)
                - for POSIX storage, the storage will need to be mounted directly into the containers (e.g. a 'volume' path in Docker or a PVC in kubernetes).  Since the storage will be mounted by several containers, it will need to be a _shared_ file-system which supports writes from multiple hosts. 
                - in the SI configuration for POSIX storage the `org.opencadc.inventory.storage.fs.baseDir` parameter must point to the location that the storage is mounted _inside the container._
            - [Swift Object Store API](https://github.com/opencadc/storage-inventory/tree/master/cadc-storage-adapter-swift) (e.g. CEPH Object Store)
                - for Swift storage, the Ceph gateway URL must be reachable from inside the containers.
        - Whatever storage you use, it must be directly available to certain storage inventory services and applications.  These are
            - **minoc** -- this service will write files to and retrieve files from storage.
            - **critwall** -- only required in a Storage Inventory deployment with more than one Storage site and a Global site.  This application will scan the site inventory database for artifacts with metadata but no associated local file copy in storage, then negotiate the transfer of those files with the Global site **raven** service.
            - **tantar** -- this application verifies the content of the storage system against the inventory database, so will need to read files from the storage.

1. **Database** 

    - The database will be accessed by all SI site services and applications, so must be reachable from wherever you deploy your containers.
    - Storage Inventory services have been tested with postgres 12.3.  Newer versions will likely work as well.
    - As the content in the database grows, you'll need to think about its storage requirements.  For the PG data and indices, this is roughly 1KB/artifact (storage site) or 1.5KB/artifact (global site)
    - In the following, the database being created is called `si_db`, but you can change that name as you see fit.  Whatever you choose, it will need to be referenced in the service and application configuration.
        - Initialize the database: `initdb -D /var/lib/postgresql/data --encoding=UTF8 --lc-collate=C --lc-ctype=C`
        - You might need to change the data location (`-D`), depending on your postgres installation and hardware layout.
    - As the postgres user, create a file named [si.dll](si.dll) with the linked content, edit to add appropriate passwords, and run `psql -f si.dll -a`
    - This will create three users:
        - `tapadm` - privileged user.  Manages the tap schema with permissions to create, alter, and drop tables. Used by:
            - **luskan**
        - `tapuser` - unprivileged user.  Used by the `luskan` service to query the inventory database. Used by:
            - **luskan**
            - **raven**
        - `invadm` - privileged user. Manages the inventory schema with privileges to create, alter, and drop tables, and is also used to insert, update, and delete rows in the inventory tables. Used by:
            - **critwall**
            - **fenwick**
            - **minoc**
            - **ratik**
            - **ringhold**
            - **tantar**
    - NOTE: The first service to connect to the database will create and initialize the tables and indices using the above privileged user roles.
    - a basic example of a developer deployment of a compatible database can be found in [here](https://github.com/opencadc/docker-base/tree/master/cadc-postgresql-dev). (Except _pgsphere_ is not required...)

1. **Proxy**

    - x509 proxy certificates -- the longer certificate chain for these might not be supported by all proxies.  These proxy certificates are required for some A&A mechanisms.
        - **haproxy**
            - haproxy will need to be compiled against `openssl 1.0.2k` or a compatible version. Newer versions of `openssl` do not support proxy certificates.
            -  the environment variable `OPENSSL_ALLOW_PROXY_CERTS=1` needs to be set in the proxy environment.
        - **nginx**
            - untested, but likely has the same requirements and restrictions as haproxy for proxy certificates.
    - SSL termination -- although you will need to support https connections to your proxy, the SI containers do not accept https connections.  Because of this, your proxy must terminate the SSL connection and pass only straight http connections to the containers.
    - a basic example of a developer deployment of a compatible instance of haproxy can be found [here](https://github.com/opencadc/docker-base/tree/master/cadc-haproxy-dev).

1. **Registry service**

    - Container image: Use the latest `core/reg` image from `images.opencadc.org`
    - See the [pencadc registry server](https://github.com/opencadc/reg/tree/master/cadc-registry-server) documentation for configuarion details.
    - 'resourceIDs'
        - you will need to choose resourceIDs for services and resources that you deploy, and which need to be referenced by other services and applications.  For example, if your `minoc` service is available at the URL `https://www.example.org/minoc` and you choose a resourceID of `ivo://example.org/minoc`, the registry config for that resource (in the `reg-resource-caps.properties` file for the registry service) would look like:

            > ivo://example.org/minoc = `https://www.example.org/minoc`

            This resourceID will appear in, for example, the `minoc.propertries` file in the `minoc` service config:

            > org.opencadc.minoc.resourceID = ivo://example.org/minoc

    - test with, e.g., `curl https://www.example.org/reg/resource-caps`

1. **baldur**

    - Container image: Use the latest `storage-inventory/baldur` image from `images.opencadc.org`
    - See the [opencadc storage inventory baldur](https://github.com/opencadc/storage-inventory/tree/master/baldur) documentation for configuarion details.
    - test with, e.g., `curl https://www.example.org/baldur/availability`

1. **minoc**
    - Container image: Use the latest `storage-inventory/minoc` image from `images.opencadc.org`
    - See the [opencadc storage inventory minoc](https://github.com/opencadc/storage-inventory/tree/master/minoc) documentation for configuarion details.
        - the 'inventory' account in the `catalina.properties` file is the `invadm` account created when the database was configured above.
    - when configuring the storage adapter for minoc to use (see **Storage** above) be sure to test that the containers deployed on your system can access the provided storage.
    - test with, e.g., `curl https://www.example.org/minoc/availability`

1. **luskan**

    - Container image: Use the latest `storage-inventory/luskan` image from `images.opencadc.org`
    - See the [opencadc storage inventory luskan](https://github.com/opencadc/storage-inventory/tree/master/luskan) documentation for configuarion details.
        - the 'uws' account in the `catalina.properties` file is the `tapadm` account created when the database was configured above.
        - the 'query' account in the `catalina.properties` file is the `tapuser` account.
        - (Should probably be in the luskan docs)  For the `cadc-tap-tmp.properties` file:
            - the `{server name}` in the `baseURL` is the public name of the proxy fronting your `luskan` service (e.g. `www.example.org`).
            - the `{luskan path}` is the path to your `luskan service` (likely just 'luskan', e.g. `www.example.org/luskan`).
            - the `{local directory}` in `baseStorageDir` the is the location _on the container_ which the `baseURL` `/results` path will be mapped to.
    - test with, e.g., `curl https://www.example.org/luskan/availability`






    

##  Healthchecks and Monitoring

- All Storage Inventory services expose an `/availability` endpoint which can be used for both monitoring and healthchecks.




## FAQ 
Additional FAQ can be found [`here`](https://github.com/opencadc/storage-inventory/blob/master/docs/FAQ.md)

- I'm sure that my service/application is configured with the correct inventory database url/username/password but it is failing to initialize.
    - check that the database pg_hba.conf file allows connections from the host that you're running the service on. If you're running services in a docker swarm or a kubernetes cluster, the egress IP might not be obvious.
    - in the service configuration files, check that the configuration keys are correct. For example, the key for the database url for the application fenwick is `org.opencadc.fenwick.inventory.url`; the key for the database URL for the service minoc is `org.opencadc.minoc.inventory.url`. It is easy to cut and paste between config files and forget to change the key.





