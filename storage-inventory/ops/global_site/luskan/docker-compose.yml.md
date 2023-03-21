```
version: '2.4'
services:
  globalluskan:
    # this is a docker-internal name, but will show up in, e.g., connections to postgres
    hostname: luskannode
    image: images.opencadc.org/luskan:latest
    container_name: globalluskan
    volumes:
      - /your/local/path/globalluskan/config:/config:ro
      - asyncdata:/data:rw
      - /your/local/path/globalluskan/config/cacerts:/config/cacerts:ro
    # Change this port to match your proxy config
    ports:
      - 48080:8080
    user: tomcat:tomcat
volumes:
  asyncdata:
    driver_opts:
      type: tmpfs
      device: tmpfs
      o: size=100m,uid=8675309
  cacerts:
    external: true
```
