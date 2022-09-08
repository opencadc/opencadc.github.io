# Storage Inventory query service - luskan

## Required configuration (below /config in container instance)
See the example configuration files for more information
- [catalina.properties](config/catalina.properties)
  - base tomcat connector configuration
- [luskan.properties](config/luskan.properties)
  - service specific configuration, including authorization schemes, storage adapter configuration.
- [LocalAuthority.properties](config/LocalAuthority.properties)
  - Sets the resource IDs for the ancillary services that are required for A&A.  The resource IDs are resolved via a registry lookup.
- cadcproxy.pem
  - x509 proxy certificate
  - for luskan, the user identified by this certificate needs to be able to call A&A services and verify the identity and group membership of _other_ users. 
- (optional) cacerts/*
  - certificates for CAs which are used to sign user x509 certificates.
- (optional) [war-rename.conf](config/war-rename.conf)
  - By default, the service expects to be available as, e.g. `https://www.example.net/luskan` (replace `https://www.example.net` with the proxy info configured in `catalina.properties`).  If you wish to change the name of the service, e.g. from `/luskan` to `/yaytap`, or the path to the service, e.g. from `/luskan` to `/yay/tap`, you will need to use the war-rename.conf file to rename the war file in the container at start-up.  See the file for examples.