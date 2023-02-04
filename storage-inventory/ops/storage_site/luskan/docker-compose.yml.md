```
version: '2.4'
services:
  luskan:
    # this is a docker-internal name, but will show up in, e.g., connections to postgres
    hostname: luskannode
    image: images.opencadc.org/luskan:latest
    container_name: luskan
    volumes:
      - /your/local/path/luskan/config:/config:ro
      - asyncdata:/data:rw
      - /your/local/path/luskan/config/cacerts:/config/cacerts:ro
    # Change this port to match your proxy config
    ports:
      - 28080:8080
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
