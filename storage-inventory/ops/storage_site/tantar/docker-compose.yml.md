```
version: '2.4'
services:
  tantar:
    hostname: tantarnode
    image: images.opencadc.org/tantar:latest
    volumes:
      - /your/local/path/tantar/config:/config:ro
    user: opencadc:opencadc
```
