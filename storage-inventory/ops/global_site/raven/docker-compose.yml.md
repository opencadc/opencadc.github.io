```
version: '2.4'
services:
  raven:
    image: images.opencadc.org/raven:latest
    volumes:
      - /your/local/path/raven/config:/config:ro
      - /your/local/path/raven/config/cacerts:/config/cacerts:ro
    # Change this port to match your proxy config
    ports:
      - 38080:8080
    user: tomcat:tomcat
```    
