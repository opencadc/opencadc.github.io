```
version: '2.4'
services:
  ringhold:
    # this is a docker-internal name, but will show up in, e.g., connections to postgres
    image: images.opencadc.org/ringhold:latest
    volumes:
      - /your/local/path/ringhold/config:/config:ro
    user: opencadc:opencadc
``` 
