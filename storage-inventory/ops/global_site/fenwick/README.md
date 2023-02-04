# Storage Inventory incremental metadata sync - fenwick

## Example docker-compose.yml
This [`docker-compose.yml`](docker-compose.yml) file will need to be editted for your local environment.

## Required configuration (below /config in container)

```
 ls -1 config/
cadcproxy.pem
fenwick.properties
```

See the example configuration files for more information
- [fenwick.properties](config/fenwick.properties)
  - application-specific configuration
- cadcproxy.pem
  - This proxy certificate must be for a user that is authorized to access services to retrieve files and to query luskan.  This user should appear in the groups that are authorized via the baldur service to access files in collections.  This user should also be in an `allowedGroup` in the luskan service configuration.
  - This is very CADC-specific at this point.
- **optional:** [artifact-filter.sql](config/artifact-filter.sql)
  - This file is **only** used if `artifactSelector` in the `fenwick.properties` file is set to `filter`.  
  - The file is a simple sql file and must *only* contain a WHERE clause which restricts the results returned when the fenwick application queries the remote `queryService`.