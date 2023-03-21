```
version: '2.4'
services:
  baldur:
    image: images.opencadc.org/baldur:latest
    volumes:
      - /your/local/path/baldur/config:/config:ro
      - /your/local/path/baldur/config/cacerts:/config/cacerts:ro
    # Change this port to match your proxy config
    ports:
      - 58080:8080
    user: tomcat:tomcat
```    
