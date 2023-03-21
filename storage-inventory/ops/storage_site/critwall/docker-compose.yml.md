```
version: '2.4'
services:
  critwall:
    hostname: critwallnode
    image: images.opencadc.org/critwall:latest
    volumes:
      - /your/local/path/tantar/config:/config:ro
    user: opencadc:opencadc
```
