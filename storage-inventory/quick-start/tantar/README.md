# Storage Inventory file validation - tantar

## Required configuration (below /config in container)
See the example configuration files for more information
- [tantar.properties](config/tantar.properties)
  - application specific configuration, including storage adapter configuration.
- storage-adapter-specific configuration, e.g. [cadc-storage-adapter-swift.properties](config/cadc-storage-adapter-swift.properties)
  - This will change depending on what storage type (class name) you specify in the minoc.properties file.
    - [posix file system](https://github.com/opencadc/storage-inventory/tree/master/cadc-storage-adapter-fs)
    - [swift](https://github.com/opencadc/storage-inventory/tree/master/cadc-storage-adapter-swift)
    - [s3](https://github.com/opencadc/storage-inventory/tree/master/cadc-storage-adapter-s3)
- cadcproxy.pem
  - This proxy certificate must be for a user that is authorized to access services to retrieve files and to query luskan.  This user should appear in the groups that are authorized via the baldur service to access files in collections.  This user should also be in an `allowedGroup` in the luskan service configuration.