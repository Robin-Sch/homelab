Edit `grafana/custom.ini` with the correct domain and keycloak (SSO) credentials

To upload docker container logs into loki, use this:

```
x-logging: &logging
    logging:
        driver: loki
        options:
            loki-url: "http://${IP}:3100/loki/api/v1/push"
            loki-timeout: "1s"
            loki-max-backoff: "800ms"
            loki-retries: "2"
            mode: "non-blocking"

services:
    xxx:
        <<: *logging
        container_name: ...
```
