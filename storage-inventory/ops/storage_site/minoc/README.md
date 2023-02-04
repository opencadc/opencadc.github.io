# Storage Inventory file service - minoc

## Example docker-compose.yml
This [`docker-compose.yml`](docker-compose.yml) file will need to be editted for your local environment.




## Required configuration (below /config in container instance)

```
$ ls -1 config/
LocalAuthority.properties
cadc-storage-adapter-???.properties
catalina.properties
minoc.properties
RsaSignaturePub.key
```

See the example configuration files for more information
- [catalina.properties](config/catalina.properties)
  - base tomcat connector configuration
- [minoc.properties](config/minoc.properties)
  - service specific configuration, including authorization schemes, storage adapter configuration.
- [LocalAuthority.properties](config/LocalAuthority.properties)
  - Sets the resource IDs for the ancillary services that are required for A&A.  The resource IDs are resolved via a registry lookup.
  - The config in this example file is very CADC-specific.
- storage-adapter-specific configuration, e.g. [cadc-storage-adapter-swift.properties](config/cadc-storage-adapter-swift.properties), [cadc-storage-adapter-fs.properties](config/cadc-storage-adapter-fs.properties)
  - This will change depending on what storage type (class name) you specify in the minoc.properties file.
    - [posix file system](https://github.com/opencadc/storage-inventory/tree/master/cadc-storage-adapter-fs)
    - [swift](https://github.com/opencadc/storage-inventory/tree/master/cadc-storage-adapter-swift)
    - [s3](https://github.com/opencadc/storage-inventory/tree/master/cadc-storage-adapter-s3)
- cadcproxy.pem
  - x509 proxy certificate
  - for minoc, the user identified by this certificate needs to be able to call A&A services and verify the identity and group membership of _other_ users. 
  - This is very CADC-specific at this point.
- RsaSignaturePub.key
  - Key for verifying OIDC tokens.  
  - This is very CADC-specific at this point.
- **optional:** cacerts/*
  - certificates for CAs which are used to verify remote service SSL certs. 
- raven_rsa.pub
  - if the minoc service will receive pre-authorized URLs from file requests redirected from the _Global site_ `raven` service, this key is used to decode the URLs.
  - should be optional, but isn't.  If you don't actually need it (because you don't have a _Global site_), you should be able to use any valid x509 certificate here as a placeholder.  
  - This is very CADC-specific at this point.
- **optional:** [minoc-availability.properties](config/minoc-availability.properties)
  - the minoc service state can be changed by calls to the `/minoc/availability` end-point.  This sets the x509 DN of users which can make those calls.  More than one user can be specified by specifying the `users` key for each user DN.
- **optional:** [war-rename.conf](config/war-rename.conf)
  - By default, the service expects to be available as, e.g. `https://www.example.net/minoc` (replace `https://www.example.net` with the proxy info configured in `catalina.properties`).  If you wish to change the name of the service, e.g. from `/minoc` to `/yayfiles`, or the path to the service, e.g. from `/minoc` to `/yay/minoc`, you will need to use the war-rename.conf file to rename the war file in the container at start-up.  See the file for examples.





## Usage

- using `curl` or `cadcput/cadcget` (from cadcdata python package)
  - note: `cadcdata` utilities are recommended.  There is a 5GiB limit on any file uploaded or downloaded with other tools.

File upload
```
curl -T observation1.fits.fz -XPUT -E ~/.ssl/cadcproxy.pem  "https://ws-cadc.canfar.net/minoc/files/test:TEST/observation1.fits.fz"

cadcput --cert ~/.ssl/cadcproxy.pem test:TEST/observation1.fits.fz observation1.fits.fz
```

File download
```
curl -XGET -E ~/.ssl/cadcproxy.pem "https://ws-cadc.canfar.net/minoc/files/test:TEST/observation1.fits.fz"

cadcget --cert ~/.ssl/cadcproxy.pem -o observation1.fits.gz test:TEST/observation1.fits.fz
```
