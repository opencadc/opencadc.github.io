```
# database connection pools
## Connection pool for UWS schema in global_db database
org.opencadc.luskan.uws.maxActive=16
# tapadm is a Privileged (rw) user
org.opencadc.luskan.uws.username=tapadm
org.opencadc.luskan.uws.password=mypassword1
org.opencadc.luskan.uws.url=jdbc:postgresql://yourglobaldbhost:5432/global_db

## Connection pool for TAP schema in global_db database
org.opencadc.luskan.tapadm.maxActive=16
# tapadm is a Privileged (rw) user
org.opencadc.luskan.tapadm.username=tapadm
org.opencadc.luskan.tapadm.password=mypassword1
org.opencadc.luskan.tapadm.url=jdbc:postgresql://yourglobaldbhost:5432/global_db

## Connection pool for running tap queries in inventory schema in global_db
org.opencadc.luskan.query.maxActive=16
# tapuser is a non-privileged (ro) user
org.opencadc.luskan.query.username=tapuser
org.opencadc.luskan.query.password=mypassword2
org.opencadc.luskan.query.url=jdbc:postgresql://yourglobaldbhost:5432/global_db

# Tomcat servlet connector config
tomcat.connector.connectionTimeout=1800000
tomcat.connector.keepAliveTimeout=1800000
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
