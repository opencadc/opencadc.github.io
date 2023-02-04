```
# service identity. This is the service registry identifier for _this_ service.  This is required so
# the service can inject its location into the inventory database (used by Global site)
org.opencadc.luskan.resourceID=ivo://your.resourceID/global/luskan

# Path within container instance for async query results to be stored.  
# Ideally, this path is to storage which is shared among all instances of 
# luskan with the same resourceID.  
org.opencadc.luskan.resultsDir=/data

# true if luskan is running on a Storage site, false or not set if
# running on a Global site
org.opencadc.luskan.isStorageSite=false

# users in allowedGroups are authorized to make queries against this service.  One group needs to include
# the user that runs Storage Inventory applications
org.opencadc.luskan.allowedGroup=ivo://your.resourceID/gms?mystaffgroup
org.opencadc.luskan.allowedGroup=ivo://your.resourceID/gms?myappgroup

```
