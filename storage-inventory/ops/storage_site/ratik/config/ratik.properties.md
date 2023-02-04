```
org.opencadc.ratik.logging = info

# inventory database settings
org.opencadc.inventory.db.SQLGenerator=org.opencadc.inventory.db.SQLGenerator
org.opencadc.ratik.inventory.schema=inventory
org.opencadc.ratik.inventory.username=invadm
org.opencadc.ratik.inventory.password=yourpassword
org.opencadc.ratik.inventory.url=jdbc:postgresql://yourdbhost:5432/si_db

# artifact uri bucket filter
org.opencadc.ratik.buckets=0-f

# selectivity
org.opencadc.ratik.artifactSelector=filter

# remote inventory query service (luskan)
org.opencadc.ratik.queryService=ivo://your.Global.resourceID/global/luskan

# local site type, true = global site, false = storage site
org.opencadc.ratik.trackSiteLocations=false
```
