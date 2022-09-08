## Proxy configuration

- Storage inventory services require a proxy to perform SSL termination on service calls and to set HTTP headers when optional x509 proxy certificates are used.
- NOTE: versions of `openssl >1.0.2k` do not support x509 proxy certificates.  You'll need to ensure that your proxy is compiled with a version of `openssl` which supports these.
  - For supported versions of `openssl`, the environment of the proxy will need to have `OPENSSL_ALLOW_PROXY_CERTS=1` set.
- Simple [haproxy.cfg](haproxy.cfg)