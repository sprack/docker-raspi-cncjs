# docker-raspi-cncjs
CNCjs docker image for Raspberry Pi

## Building

As simple as running `make`.

If you wish to change the name of the container or push to your own public repo change this line in the `Makefile`:

```
NAME = sprack/docker-raspi-cncjs
```

To change the version of cncjs installed modify the `VERSION` file. This matches the versions available here: https://github.com/cncjs/cncjs/releases

## Running cncjs as a service

### Install Docker

`curl -sSL https://get.docker.com | sh`

`systemctl enable docker.service && systemctl start docker.service`

### Pull cncjs docker image

`docker pull sprack/docker-raspi-cncjs:latest`

### Create a cncrc file

The official example config exists here: https://github.com/cncjs/cncjs/blob/master/examples/.cncrc

A more complete description of the flags is here: https://github.com/cncjs/cncjs/issues/242#issuecomment-352294549

```
{
    "state": { "checkForUpdates": false },
    "watchDirectory": "/path/to/dir",
    "controller": "Grbl",
    "ports": [
        {
            "comName": "/dev/ttyAMA0",
            "manufacturer": ""
        }
    ]
}
```

### Running manually

```
docker run --rm -ti \
  --privileged \
  --publish 80:8000 \
  --volume /dev:/dev \
  --volume ~/.cncrc:/root/.cncrc \
  --volume /path/to/dir:/watchdir \
  --name cncjs
  sprack/docker-raspi-cncjs:latest
```

### Running as a systemd service:

```
echo '[Unit]
Description=CNCJS Container
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=/usr/bin/docker pull sprack/docker-raspi-cncjs:latest
ExecStart=/usr/bin/docker run --rm -t \
  --privileged \
  --publish 80:8000 \
  --volume /dev:/dev \
  --volume /home/someuser/.cncrc:/root/.cncrc \
  --volume /path/to/dir:/watchdir \
  --name %n \
  sprack/docker-raspi-cncjs:latest
ExecStopPost=/usr/bin/docker stop %n
ExecStop=/usr/bin/docker rm %n
ExecReload=/usr/bin/docker restart %n

[Install]
WantedBy=multi-user.target' > /lib/systemd/system/docker-cncjs.service
```

Then enable and start the service.

```
systemctl enable docker-cncjs.service && systemctl start docker-cncjs.service
```

This will start the cncjs daemon as a container on your host.

You should then be able to connect to the host via a browser at http://<host ip>/

To check the status of the service run: `systemctl status docker-cncjs.service`

To check the log of the service for errors run: `journalctl -u docker-cncjs.service`
