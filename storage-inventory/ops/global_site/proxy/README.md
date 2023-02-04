## Proxy configuration

- Storage inventory services require a proxy to perform SSL termination on service calls and to set HTTP headers when optional x509 proxy certificates are used.
- The information below assumes you're using [haproxy](https://www.haproxy.org).
- NOTE: versions of `openssl >1.0.2k` do not support x509 proxy certificates.  You'll need to ensure that your proxy is compiled with a version of `openssl` which supports these.  This requirement may change when tokens are usable with Storage Inventory services.
  - For supported versions of `openssl`, the environment of the proxy will need to have `OPENSSL_ALLOW_PROXY_CERTS=1` set.  For `systemd`-based OSes (RHEL 7+), it is sufficient to create `/etc/systemd/system/haproxy.service.d/override.conf`:
```
[Service]
Environment="OPENSSL_ALLOW_PROXY_CERTS=1"
```
- Example [haproxy.cfg](haproxy.cfg)