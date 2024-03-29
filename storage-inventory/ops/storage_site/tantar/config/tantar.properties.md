```
# logging level
org.opencadc.tantar.logging = info

# Prefix of the storage buckets that this instance of tantar will validate against.  The interpretation of this
# might differe based on which storageAdapter is being used.  A single value or a range can be given.
# Multiple instances of tantar can run if they are each configured with non-overlapping bucket ranges.
org.opencadc.tantar.buckets = 0-f

# set the policy to resolve conflicts of files.  This sets the definitive source for the storage
# site: the inventory database or the storage itself.  In general, InventoryIsAlwaysRight will be used.
# The alternative is StorageIsAlwaysRight.
# InventoryIsAlwaysRight -- artifacts in the database are assumed to be correct and complete.  Any files
#  not in the database are assumed to be wrong and are deleted.  
# StorageIsAlwaysRight -- the files in storage are assumed to be correct and complete.  Artifacts in the database
#  with no matching file are deleted.  
org.opencadc.tantar.policy.ResolutionPolicy = org.opencadc.tantar.policy.InventoryIsAlwaysRight

# set whether to report all activity or to perform any actions required. 
org.opencadc.tantar.reportOnly = false

# inventory database settings
## This may change depending on what the database server is running.  Currently only supports Postgresql 10+.
org.opencadc.inventory.db.SQLGenerator=org.opencadc.inventory.db.SQLGenerator
## Name of the inventory schema in the configured database.  Currently must be 'inventory'....
org.opencadc.tantar.inventory.schema=inventory

# database pool configuration
org.opencadc.tantar.inventory.username=invadm
org.opencadc.tantar.inventory.password=yourpassword
org.opencadc.tantar.inventory.url=jdbc:postgresql://yourdbhost:5432/si_db

# storage back end.  Identifies the class of storage being used.  Each class comes with its own
# configuration file describing the access method, authentication keys, etc. See the [Storage Inventory documentation](https://github.com/opencadc/storage-inventory) for options.
org.opencadc.inventory.storage.StorageAdapter=org.opencadc.inventory.storage.swift.SwiftStorageAdapter
```
