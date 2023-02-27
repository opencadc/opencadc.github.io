

# CADC Storage Inventory Architecture and Deployment


Read the entire document or jump to a relevant section below.


### Table of Contents

1. [Introduction](#introduction)
    * [Key Storage Inventory Terms and Concepts](#key-storage-inventory-terms-and-concepts)
2. [Overview of the System](#overview-of-the-system)
    * [System Architecture](#system-architecture)
    * [Basic Standalone Storage Site](#basic-standalone-storage-site)
    * [Supporting Infrastructure and Services](#supporting-infrastructure-and-services)
    * [Client Software](#client-software)
3. [Deployment Prerequisites](#deployment-prerequisites)
    * [Hardware Requirements](#hardware-requirements)
    * [Software Requirements](#software-requirements)
4. [Deployment Steps](#deployment-steps)
5. [Configuration and Customization](#configuration-and-customization)
    * [Web Services Configuration](#web-services-configuration)
    * [Application Configuration](#application-configuration)
    * [A word about credentials](#a-word-about-credentials)
6. [Management and Monitoring](#management-and-monitoring)    
7. [Maintenance and Upgrades](#maintenance-and-upgrades)
8. [Conclusion](#conclusion)
    * [Deployment Scenarios](#deployment-scenarios)
    * [Troubleshooting Guide](#troubleshooting-guide)


## Introduction

### Key Storage Inventory Terms and Concepts

- _Artifact_: a representation of a file and its metadata in SI. File and artifact are used interchangebly through the document
- _resourceID/serviceID_: Unique ID in a URI form associated with a deployed service. Examples: `ivo://opencadc.org/minoc`
- _bucket_: unit of work for SI applications. More details TBD.

## Overview of the System

### System Architecture
A detailed description of the data model, features and limitations can be found [here](https://github.com/opencadc/storage-inventory/tree/master/docs)

#### Basic Standalone Storage Site
A Storage site maintains an inventory of the files stored at a particular location, and provides mechanisms to access (**minoc**) those files and query (**luskan**) the local inventory. 
If you have files in multiple data centres, or more than one storage platform in one data centre (e.g. some files on a posix file-system and some on Ceph object storage), you would 
have more than one Storage site, and each site would run its own services, database, storage, and applications.

<center>
<img src="SingleSite.drawio.png" width="500">
</center>

An SI site consists of following:
- Front-end Web services:
    - [`minoc`](https://ws-cadc.canfar.net/minoc/): REST based file service that supports HEAD, GET, PUT, POST, DELETE operations.
    - [`luskan`](https://ws-cadc.canfar.net/luskan/): Web Service used to query artifact metadata using the [`IVOA Table Access Protocol`](https://www.ivoa.net/documents/TAP/)
- Resources:
    - **Inventory database**: is the ledger tracking all the files storage at the site. Applications and services will access this database in parallel so it will need to have good performance, 
especially as the content as the site grows.
    - **Storage platform**: the actual back end storage platform. Currently, SI supports two backends: POSIX filesystem and the Swift Object Store API (e.g. CEPH Object Store)
- Applications that run at a storage site:
    - **tantar**: file-validate application that compares the inventory database against the back end storage.

#### Supporting Infrastructure and Services
The following external services are required for the SI deployment. Images with default implementations are available: 
   - **proxy/ingress**: All the calls the front-end Web services need to go through a proxy/ingress that provides SSL termination and ensures that authentication 
     headers are correctly set before being routed to the actual service. The proxy needs a public IP address and a valid SSl certificate (e.g. [Let's Encrypt](https://www.letsencrypt.org)).
   - [`reg`](https://ws.cadc-ccda.hia-iha.nrc-cnrc.gc.ca/reg/): Used to map service IDs to the actual URLs where the service is deployed decoupling the service from its actual location. The simplest **registry** is a static page but the **reg** container
     included with the SI distribution allows the information to be configured on the fly.
   - [`baldur`](https://ws.cadc-ccda.hia-iha.nrc-cnrc.gc.ca/baldur): permissions service API using configurable rules to grant access based on resource identifiers (Artifact.uri values in the inventory data model).
     his service is required if Authentication and Authorization (A&A) is required for the SI deployment. Most of the time, **baldur** works with a Group Management Service (GMS) and/or User Service.
     
#### Client Software
Generic HTTP client tools such as [`curl`](https://curl.se) or [`wget`](https://www.gnu.org/software/wget/) can be used to interact with the SI, however multi-step operations such as transfer negotiations or transfer of large files with
SI transactions might require dedicated scripts.

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
Storage Nodes:
   - High capacity. Cores for cutouts TBD
Processing nodes:
   - applications don't consume a lot of memory (~1GB-4GB per instance) although some (minoc, tantar, critwall) are multithreaded and can take advantage of multiple cores.

### Software Requirements
The software requirements for deploying the system are:

#### Processing node requirements (where services and applications run)
In a production setting it would be best not to mix services and applications on the same nodes in order to ensure that service quality isn't affected by things like metadata validation. A single node might suffice in a test deployment whereas you'll need several nodes for a production deployment.
   - docker-ce (20.10 or newer)
   - orchestration software: docker-compose (docker-compose file version 2.4 or newer), Swarm or Kubernetes). 
   - [`haveged`](https://www.issihosts.com/haveged/) (or other entropy-generating service) this is only necessary on hosts running the services. 
     
#### Database requirements
   - PG 12.3 or newer 
     

## Deployment Steps
TBD

## Configuration and Customization

Services and applications expect all configuration files and credentials to be available in the container instance below the directory `/config`. Config files are plain-text key-value files, 
with the key usually being of the form org.opencadc.serviceName.keyName configuration descriptions. Details for each service/application:

### Web Services Configuration
Web Services:
- [`minoc`](https://github.com/opencadc/storage-inventory/tree/master/minoc)
- [`luskan`](https://github.com/opencadc/storage-inventory/tree/master/luskan)
- [`baldur`](https://github.com/opencadc/storage-inventory/tree/master/baldur)
- [`reg`](https://github.com/opencadc/reg/tree/master/reg)
- [`haproxy`](https://github.com/opencadc/docker-base/tree/master/cadc-haproxy-dev)

### Application Configuration:
- [`tantar`](https://github.com/opencadc/storage-inventory/tree/master/tantar)


### Management and Monitoring
The system must be managed and monitored to ensure that it is running smoothly and efficiently. The following tools and techniques can be used to manage and monitor the system:

- Docker Compose: Docker Compose can be used to manage the system's components and perform common tasks, such as starting and stopping the system, checking the status of the system, and updating the system.
- Logs: The system generates logs that can be used to monitor its performance and diagnose problems. The logs can be accessed using the Docker Compose command.
- Metrics: The system exposes various metrics that can be used to monitor its performance, such as CPU and memory usage, network traffic, and system load. The metrics can be accessed using tools such as Prometheus and Grafana.
- Alerts: Alerts can be configured to notify the administrator if the system encounters problems, such as high CPU or memory usage, or if the system stops responding. The alerts can be configured using tools such as Prometheus Alert Manager.

## Maintenance and Upgrades

The system must be regularly maintained and upgraded to ensure that it continues to function smoothly and efficiently. The following tasks should be performed on a regular basis to maintain the system:

- Software updates: Regular software updates must be installed to address known vulnerabilities and prevent potential security breaches.
- Backups: Regular backups of the system's data must be taken to prevent data loss in case of hardware failures or other problems.
- System tuning: The system's performance should be regularly monitored and tuned to ensure that it is running efficiently.


## Conclusion


### Deployment Scenarios

This section provides detailed information on various deployment scenarios, including typical use cases, hardware requirements, and deployment steps.

### Troubleshooting Guide
I'm sure that my service/application is configured with the correct inventory database url/username/password but it is failing to initialize.
check that the database pg_hba.conf file allows connections from the host that you're running the service on. If you're running services in a docker swarm or a kubernetes cluster, the egress IP might not be obvious.
in the service configuration files, check that the configuration keys are correct. For example, the key for the database url for the application fenwick is org.opencadc.fenwick.inventory.url; the key for the database URL
for the service minoc is org.opencadc.minoc.inventory.url. It is easy to cut and paste between config files and forget to change the key.

This section provides a step-by-step guide to troubleshoot common issues that may arise during deployment.

Additional FAQ can be found [`here`](https://github.com/opencadc/storage-inventory/blob/master/docs/FAQ.md)


