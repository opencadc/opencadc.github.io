```
# logging level
org.opencadc.fenwick.logging = info

# inventory database settings
## This may change depending on what the database server is running.  Currently only supports Postgresql 10+.
org.opencadc.inventory.db.SQLGenerator=org.opencadc.inventory.db.SQLGenerator
## Name of the inventory schema in the configured database.  Currently must be 'inventory'....
org.opencadc.fenwick.inventory.schema=inventory
## Priviliged inventory user account
org.opencadc.fenwick.inventory.username=invadm
org.opencadc.fenwick.inventory.password=yourpassword
org.opencadc.fenwick.inventory.url=jdbc:postgresql://yourglobaldbhost:5432/global_db

# Enable Storage Site lookup to track site locations for artifacts
# This changes the inventory artifact schema with a global site including the artifact's site location.
## true for global site; false for storage site
org.opencadc.fenwick.trackSiteLocations=true

# remote inventory query service (luskan)
## If this is a storage site, queryService will be for the *global* luskan.
## If this is a global site, queryService will be for a *site* luskan.  In this case, there were be a fenwick instance
## for each site the global site is monitoring.
org.opencadc.fenwick.queryService=ivo://your.resourceID/site1/luskan

# artifact selectivity
## If set to all, all artifacts at the above queryService will be returned.  
## If set to filter, an artifact-filter.sql file must be present in /config, and its contents will be
## used in the WHERE clause of the queryService query to restrict the collections/artifacts that are returned.
org.opencadc.fenwick.artifactSelector=all

# time in seconds to retry processing after encountering an error.
org.opencadc.fenwick.maxRetryInterval=180
```
