org.opencadc.critwall.logging = info

# inventory database settings
org.opencadc.inventory.db.SQLGenerator=org.opencadc.inventory.db.SQLGenerator
org.opencadc.critwall.inventory.schema=inventory
org.opencadc.critwall.inventory.username=invadm
org.opencadc.critwall.inventory.password=yourpasword
org.opencadc.critwall.inventory.url=jdbc:postgresql://yourdbhost:5432/si_db

# global transfer negotiation service (raven)
org.opencadc.critwall.locatorService=ivo://your.global.resourceID/global/raven

# storage back end
# The StorageAdapter may differ from this example based on your local storage type
org.opencadc.inventory.storage.StorageAdapter=org.opencadc.inventory.storage.swift.SwiftStorageAdapter

# file-sync
org.opencadc.critwall.buckets = 0-f
org.opencadc.critwall.threads = 8
