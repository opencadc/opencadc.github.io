```
# Path within the minoc container to the storage.  Must be read/write by the user that the container process is running as
org.opencadc.inventory.storage.fs.baseDir = /data

# Length of random bucket key appended to bucket name.  Sets the number of storage buckets (i.e. 1 = 16 buckets,
# 2 = 256 buckets, etc).  
org.opencadc.inventory.storage.fs.OpaqueFileSystemStorageAdapter.bucketLength = 3
```
