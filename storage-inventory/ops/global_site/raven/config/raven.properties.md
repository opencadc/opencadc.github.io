```
# inventory database settings
org.opencadc.inventory.db.SQLGenerator=org.opencadc.inventory.db.SQLGenerator
org.opencadc.raven.inventory.schema=inventory

org.opencadc.raven.publicKeyFile=raven_rsa.pub
org.opencadc.raven.privateKeyFile=raven_rsa

org.opencadc.raven.readGrantProvider=ivo://your.resourceID/global/baldur
org.opencadc.raven.readGrantProvider=ivo://your.resourceID/ams
org.opencadc.raven.writeGrantProvider=ivo://your.resourceID/global/baldur

org.opencadc.raven.consistency.preventNotFound=true

org.opencadc.raven.putPreference=SITE1
SITE1.resourceID=ivo://your.resourceID/minoc
SITE1.namespace=cadc:CHIMEFRB/
```
