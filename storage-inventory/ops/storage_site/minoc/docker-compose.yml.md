```
version: '2.4'
services:
  minoc:
    # this is a docker-internal name, but will show up in, e.g., connections to postgres
    hostname: minocnode
    image: images.opencadc.org/minoc:latest
    volumes:
      - /your/local/path/minoc/config:/config:ro
      - /your/local/path/minoc/config/cacerts:/config/cacerts:ro
    # Change this port to match your proxy config
    ports:
      - 18080:8080
    user: tomcat:tomcat
    
    
```
