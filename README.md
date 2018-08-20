#Objective
Run Unifi Controller in a Docker container on Red Hat Enterpries Linux.  Inspiration from jacobalberty and rednut.

## Background
I've been a long-time RHEL user, and recently became a Ubiquity (UBNT) customer.  I purchased two UAP-AC-PRO to improve the WiFi situation at home.  I deployed one unit upstairs, and the other unit in the basement to provide complete coverage.

## Description 
This is a containerized version of the Unifi Wireless Access Point controller.  It runs as a non-root user, "unifi" with UID/GID=201.

See commands.txt for examples:

To begin / build, run:
```
sudo docker build --pull=true --no-cache -t home.lab/unifi:5.5.24 . | tee ./docker-build.log
```

Then
```
sudo docker run --name=unifi --hostname=unifi \
 -p 3478:3478/udp -p 8080:8080/tcp -p 8443:8443/tcp \
 -v /nas/UniFi/data:/opt/UniFi/data:z \
 -v /nas/UniFi/logs:/opt/UniFi/logs:z \
 -d home.lab/unifi:5.5.24
```

## Volumes:

### `/opt/UniFi/data`
VOLUME ["/opt/UniFi/data"]
Database Files

### `/opt/UniFi/logs`
VOLUME ["/opt/UniFi/logs"]
Log Files

## Environment Variables:
### `TERM`
TERM=xterm-256color

## Network ports exposed (tcp, unless noted):
### Required

* 3478/udp - STUN
* 8080 - inform (AP -> Controller)
* 8443 - WebUI of Controller

### Optional

* 27117 - mongodb (not recommended)
* 8843 - Portal HTTPS
* 8880 - Portal

## Todo
* It would be nice if ENTRYPOINT or CMD could catch the "docker kill" signal and translate that to a graceful shutdown of the DB -- for example, "pkill --signal=SIGINT java"
