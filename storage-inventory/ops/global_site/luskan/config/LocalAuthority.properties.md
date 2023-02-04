```
# Service identifiers for required A&A features.  Resolved using a service registry lookup
# These are very CADC-specific -- the resourceID will need to be the resourceID of your service
## User/Group membership/identity
ivo://ivoa.net/std/GMS#search-0.1 = ivo://cadc.nrc.ca/gms           
ivo://ivoa.net/std/UMS#users-0.1 = ivo://cadc.nrc.ca/gms    
ivo://ivoa.net/std/UMS#login-0.1 = ivo://cadc.nrc.ca/gms           

## x509 credential delegation service. 
ivo://ivoa.net/std/CDP#delegate-1.0 = ivo://cadc.nrc.ca/cred
ivo://ivoa.net/std/CDP#proxy-1.0 = ivo://cadc.nrc.ca/cred

## OpenID Connect 
ivo://ivoa.net/sso#OpenID = ivo://cadc.nrc.ca/gms
## IVOA prototype token standard
ivo://ivoa.net/sso#tls-with-password = ivo://cadc.nrc.ca/gms
```
