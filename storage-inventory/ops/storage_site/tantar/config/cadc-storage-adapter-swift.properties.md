```
# Storage bucket configuration
## Buckets will be named 'bucketName-NNN' where NNN is a hexidecimal digit of length bucketLength.  So,
## a bucketLength of 1 will result in 16 buckets; a bucketLength of 2 will result in 256 buckets, etc.
## A small number (4) of additional buckets are created for system specific information.
org.opencadc.inventory.storage.swift.SwiftStorageAdapter.bucketLength=3
org.opencadc.inventory.storage.swift.SwiftStorageAdapter.bucketName=MyBucket

## If multiBucket is false, bucketLength is ignored and instead each object stored will have bucketName appended
## to its identifier.
org.opencadc.inventory.storage.swift.SwiftStorageAdapter.multiBucket=true

# Swift service configuration
org.opencadc.inventory.storage.swift.SwiftStorageAdapter.authEndpoint=http://swift.mon.server.fqdn:8080/auth/v1.0
org.opencadc.inventory.storage.swift.SwiftStorageAdapter.username=swiftuser:swiftgroup
org.opencadc.inventory.storage.swift.SwiftStorageAdapter.key=xyz
```
