Install latest version from https://github.com/prometheus/node_exporter/releases/

Create a `/etc/systemd/system/node_exporter.service` file containing:
```
[Unit]
Description=Automatically start node_exporter
After=network.target

[Service]
Type=Simple
ExecStart=/path/to/node_exporter/node_exporter --web.listen-address=IP:9100

[Install]
WantedBy=multi-user.target
```
Make sure to change the path and interface IP
```
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
```

Then change grafana prometheus to pull from IP:9100