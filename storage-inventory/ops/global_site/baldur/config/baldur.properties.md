```
# time (in seconds) the grant is considered valid 
org.opencadc.baldur.grantExpiry = 300

# list of x509 DNs for users (one per line) who are allowed to call this service
org.opencadc.baldur.allowedUser = C=ca, O=hia, OU=cadc, CN=user1
org.opencadc.baldur.allowedUser = C=ca, O=hia, OU=cadc, CN=user2

# list of groups (one per line) whose members are allowed to call this service
#org.opencadc.baldur.allowedGroup = ivo://your.resourceID/gms?MyGroup

# one or more entry properties to grant permission to access artifacts
## The `entry` value is a LABEL used to specify authorization rules for a collection
org.opencadc.baldur.entry = TEST1
## LABEL.pattern - the pattern is matched against the requested artifact's storage uri
## e.g. curl -E .ssl/cadcproxy.pem  -o /dev/null https://ws-uv.canfar.net/minoc/files/cadc:CFHT/1900515p.fits
TEST1.pattern = ^cadc:CFHT/*
## if anon = true, all users are authorized to retrieve artifacts matched by the pattern
TEST1.anon = false
## one line per group, multiple lines permitted
TEST1.readOnlyGroup = ivo://your.resourceID/gms?CADC
TEST1.readWriteGroup = ivo://your.resourceID/gms?StorageOps

org.opencadc.baldur.entry = TEST2
TEST2.pattern = ^mast:HST/*
TEST2.anon = false
TEST2.readOnlyGroup = ivo://your.resourceID/gms?CADC
TEST2.readOnlyGroup = ivo://your.resourceID/gms?OtherGroup
TEST2.readWriteGroup = ivo://your.resourceID/gms?StorageOps

org.opencadc.baldur.entry = TEST3
TEST3.pattern = ^cadc:MACHO/*
TEST3.anon = true
TEST3.readWriteGroup = ivo://your.resourceID/gms?StorageOps
```
