# Storage Inventory artifact removal -- ringhold

** USE WITH CAUTION - This is like `\rm -r *` for Storage Inventory. **

## Example docker-compose.yml
This [`docker-compose.yml`](docker-compose.yml) file will need to be editted for your local environment.

## Required configuration (below /config in container)

```
$ ls -1 config/
artifact-deselector.sql
cadcproxy.pem
ringhold.properties
```

See the example configuration files for more information
- [ringhold.properties](config/ringhold.properties)
  - application-specific configuration
- cadcproxy.pem
  - This proxy certificate must be for a user that is authorized to access services to retrieve files and to query luskan.  This user should appear in the groups that are authorized via the baldur service to access files in collections.  This user should also be in an `allowedGroup` in the luskan service configuration.
  - This is very CADC-specific at this point.
- [artifact-deselector.sql](config/artifact-deselector.sql)
  - This file should only contain an SQL `WHERE` clause that filters an inventory db query for the namespace (or collection) that is going to be **REMOVED** from the local Storage site.
  - **USE WITH CAUTION** This command will delete the artifacts from the inventory database: specifically, it will move them to the DeletedArtifact table, and the next run of tantar will remove those artifact entrie _and_ the files on storage.