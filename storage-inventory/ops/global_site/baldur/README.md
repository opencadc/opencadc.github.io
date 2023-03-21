# Storage Inventory permission service - baldur

## Example docker-compose.yml
This [`docker-compose.yml`](docker-compose.yml) file will need to be editted for your local environment.




## Required configuration (below /config in container instance)

```
$ ls -1 config/
LocalAuthority.properties
baldur.properties
catalina.properties
cadcproxy.pem
RsaSignaturePub.key
```

See the example configuration files for more information
- [catalina.properties](config/catalina.properties)
  - base tomcat connector configuration
- [baldur.properties](config/baldur.properties)
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
- **optional:** cacerts/*
  - certificates for CAs which are used to verify remote service SSL certs. 




