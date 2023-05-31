# Storage Inventory Operator and Deployment Documentation

- [Operator Documentation](ops/README.md)
	1. [Introduction](ops/README.md#introduction)
    	* [Storage Inventory Terms and Concepts](ops/README.md#storage-inventory-terms-and-concepts)
    	* [Storage Inventory Resources](ops/README.md#storage-inventory-resources)
	1. [Overview of Storage Inventory](ops/README.md#overview-of-storage-inventory)
    	* [System Architecture](ops/README.md#system-architecture)
    	* [Standalone Storage Site](ops/README.md#standalone-storage-site)
	1. [Client Software](ops/README.md#client-software)
	1. [Deployment Prerequisites](ops/README.md#deployment-prerequisites)
    	* [Hardware Requirements](ops/README.md#hardware-requirements)
    	* [Software Requirements](ops/README.md#software-requirements)
	1. [Deployment](ops/README.md#deployment)
		* [Storage Adapters](ops/README.md#configuration-storage-adapter)
			* [POSIX](ops/README.md#POSIX)
				* [Note on UID/GID on POSIX file-system](ops/README.md#note-on-uid)
			* [Swift](ops/README.md#Swift)
		* [Database](ops/README.md#configuration-database)
		* [Proxy](ops/README.md#configuration-proxy)
		* [Registry service](ops/README.md#configuration-registry)
		* [Permission service](ops/README.md#configuration-baldur) - baldur
		* [Group Membership service](ops/README.md#configuration-gms) - gms
		* [File service](ops/README.md#configuration-minoc) - minoc
		* [Query service](ops/README.md#configuration-luskan) - luskan
		* [File Location service](ops/README.md#configuration-raven) - raven
		* [Metadata sync application](ops/README.md#configuration-fenwick) - fenwick
		* [File validation application](ops/README.md#configuarion-tantar) - tantar
		* [File sync application](ops/README.md#configuration-critwall) - critwall
		* [Metadata validation application](ops/README.md#configuration-ratik) - ratik
	1. [Healthchecks and Monitoring](ops/README.md#healthchecks-and-monitoring)    
	1. [FAQ](ops/README.md#faq)
<!-- - [Example Storage Site Deployment](example_storage_site_deployment/README.md) -->
