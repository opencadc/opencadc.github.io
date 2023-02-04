# Storage Inventory Global file negotiation service - raven

## Example docker-compose.yml
This [`docker-compose.yml`](docker-compose.yml) file will need to be editted for your local environment.




## Required configuration (below /config in container instance)

```
$ ls -1 config/
LocalAuthority.properties
catalina.properties
cadcproxy.pem
raven.properties
raven_rsa
raven_rsa.pub
RsaSignaturePub.key
```

See the example configuration files for more information
- [catalina.properties](config/catalina.properties)
  - base tomcat connector configuration
- [raven.properties](config/raven.properties)
  - service specific configuration, including authorization schemes, storage adapter configuration.
- [LocalAuthority.properties](config/LocalAuthority.properties)
  - Sets the resource IDs for the ancillary services that are required for A&A.  The resource IDs are resolved via a registry lookup.
  - The config in this example file is very CADC-specific.
- cadcproxy.pem
  - x509 proxy certificate
  - for minoc, the user identified by this certificate needs to be able to call A&A services and verify the identity and group membership of _other_ users. 
  - This is very CADC-specific at this point.
- RsaSignaturePub.key
  - Key for verifying OIDC tokens.  
  - This is very CADC-specific at this point.
- raven_rsa
  - This is the private key used to encrypt file URLs from the raven service.
  - This is very CADC-specific at this point.
  - TODO: how to generate this file
- raven_rsa.pub
  - This is the public key used to decrypt the file URLs from the raven service -- other services recieve negotiated transfers from raven will need this (e.g. minoc)
  - This is very CADC-specific at this point.
  - TODO: how to generate this file
- **optional:** cacerts/*
  - certificates for CAs which are used to verify remote service SSL certs. 




