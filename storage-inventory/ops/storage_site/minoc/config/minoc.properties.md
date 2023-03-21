```
# service identity. This is the service registry identifier for _this_ service.  This is required so
# the service can inject its location into the inventory database (used by Global site)
org.opencadc.minoc.resourceID=ivo://your.resourceID/site1/minoc

# storage back end.  Identifies the class of storage being used.  Each class comes with its own
# configuration file describing the access method, authentication keys, etc. See the [Storage Inventory documentation](https://github.com/opencadc/storage-inventory) options.
org.opencadc.inventory.storage.StorageAdapter=org.opencadc.inventory.storage.swift.SwiftStorageAdapter

# inventory database settings
## This may change depending on what the database server is running.  Currently only supports Postgresql 10+.
org.opencadc.inventory.db.SQLGenerator=org.opencadc.inventory.db.SQLGenerator
## Name of the inventory schema in the configured database.  Currently must be 'inventory'....
org.opencadc.minoc.inventory.schema=inventory

# Shared public key for global raven service.  Necessary if a global site can send pre-authorized requests to 
# minoc.  E.g. if a user requests a file from the global raven service, they authenticate with that service and
# the redirect includes an auth token.  The public key is needed to decrypt the token.
org.opencadc.minoc.publicKeyFile=raven_rsa.pub

# (Optional) permission granting services 
org.opencadc.minoc.readGrantProvider=ivo://your.resourceID/global/baldur
org.opencadc.minoc.writeGrantProvider=ivo://your.resourceID/global/baldur

# (Optional, and discouraged) Disable all authorization (not authentication) checking.  Disables checking of permission granting services.
#org.opencadc.minoc.authenticateOnly=true
```

