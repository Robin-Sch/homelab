# My Homelab

Welcome to the repo for my personal homelab! 

This repo contains many compose files for my homelab. Additionally, it also includes some basic documentation on how to configure services.

### How to use this?
First go to the folder of the service you want to host, and make sure to copy all files. Then create a `.env` file with the following contents:

```
TZ=
DOCKER_DATA=
DOMAIN=
IP=
```

- `TZ` should be your timezone, e.g. Europe/London
- `DOCKER_DATA` should be the directory where you want to store database related files
- `DOMAIN` should be the domain you want to host this service on, e.g. robinsch.net
- `IP` should be your server (local) IP, e.g. tailscale/wireguard IP

Make sure to read the README (if present) and also configure the other environment variables needed.

After that, run `docker compose up -d` and it will automatically spin up all the containers needed.

I'm using traefik as my reverse proxy, if you're running a differen reverse proxy make sure it update it yourself.

### Contributing

If you want to contribute to this repo, feel free to fork it, open issues, or submit pull requests. Any feedback, suggestions, or ideas are welcome!