```
# database connection pool
## Number of active connections to open to postgres server in si_db database using inventory schema
org.opencadc.minoc.inventory.maxActive=16
## Privileged (rw) inventory user account
org.opencadc.minoc.inventory.username=invadm
org.opencadc.minoc.inventory.password=yourpasswordhere
## URL for inventory postgres, including database
org.opencadc.minoc.inventory.url=jdbc:postgresql://yourdbhost:5432/si_db

# Tomcat servlet connector config
tomcat.connector.connectionTimeout=180000
tomcat.connector.keepAliveTimeout=180000
## The following are used to describe the _proxy_ that fronts the service.  This is to allow
## the service to generate URLs that redirect properly.
tomcat.connector.secure=true
tomcat.connector.scheme=https
# FQDN for your proxy front-end, e.g. ws-cadc.canfar.net
tomcat.connector.proxyName=www.example.net
tomcat.connector.proxyPort=443

# Enable authentication with x509 proxy certificates
ca.nrc.cadc.auth.PrincipalExtractor.enableClientCertHeader=true

# (Optional) Point service to an alternate service registry. The default is https://ws.cadc-ccda.hia-iha.nrc-cnrc.gc.ca.
#ca.nrc.cadc.reg.client.RegistryClient.host=xyz.example.net

# (Optional) Turn off log4j preamble in log file, should only leave the service bits
ca.nrc.cadc.util.Log4jInit.messageOnly=true
```
