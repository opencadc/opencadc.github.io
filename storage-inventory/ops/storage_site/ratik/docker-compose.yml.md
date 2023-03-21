```
version: '2.4'
services:
  ratik:
    # this is a docker-internal name, but will show up in, e.g., connections to postgres
    image: images.opencadc.org/ratik:latest
    volumes:
      - /your/local/path/ratik/config:/config:ro
    user: opencadc:opencadc
``` 
