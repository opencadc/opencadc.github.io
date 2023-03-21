```
version: '2.4'
services:
  fenwick:
    # this is a docker-internal name, but will show up in, e.g., connections to postgres
    image: images.opencadc.org/fenwick:latest
    volumes:
      - /your/local/path/fenwick/config:/config:ro
    user: opencadc:opencadc
``` 
