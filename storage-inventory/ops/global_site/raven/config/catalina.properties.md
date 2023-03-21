```
# database connection pools
org.opencadc.raven.query.maxActive=16
org.opencadc.raven.query.username=tapuser
org.opencadc.raven.query.password=yourpassword
org.opencadc.raven.query.url=jdbc:postgresql://yourglobaldbhost:5432/global_db

# Tomcat servlet connector config
tomcat.connector.connectionTimeout=180000
tomcat.connector.keepAliveTimeout=180000
## The following are used to describe the _proxy_ that fronts the service.  This is to allow
## the service to generate URLs that redirect properly.
tomcat.connector.secure=true
tomcat.connector.scheme=https
tomcat.connector.proxyName=www.example.net
tomcat.connector.proxyPort=443

# Enable authentication with x509 proxy certificates
ca.nrc.cadc.auth.PrincipalExtractor.enableClientCertHeader=true

# Turn off preamble in log file, should only leave the json bits
ca.nrc.cadc.util.Log4jInit.messageOnly=true
```
