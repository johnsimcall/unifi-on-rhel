#Objective
Run Unifi Controller in a Docker container on Red Hat Enterpries Linux.  Inspiration from jacobalberty and rednut.

## Background
I've been a long-time RHEL user, and recently became a Ubiquity (UBNT) customer.  I purchased two UAP-AC-PRO to improve the WiFi situation at home.  I deployed one unit upstairs, and the other unit in the basement to provide complete coverage.

## Description 
This is a containerized version of the Unifi Access Point controller.
I would prefer to not use --net=host because it exposes D-BUS, and rouge stuff could reboot my host.

I need to provide a systemd unit file (not done yet.)

See commands.txt for examples:

To begin / build, run:
```
sudo docker build -t home.lab/unifi:4.8.14 . | tee ./docker-build.log
````

Then
```
sudo docker run --name=unifi -p 3478:3478/udp -p 8080:8080/tcp -p 8443:8443/tcp -d home.lab/unifi:4.8.14
```

## Volumes (out-of-date -- I'm doing this wrong because I'm not host-mounting yet):

### `/var/lib/unifi`
Configuration data

### `/var/log/unifi`
Log Files

### `/var/run/unifi`
Run Information

## Environment Variables:
### `TZ`
TimeZone. (i.e America/Chicago)

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


### Firmware
cntrl-4.8.14  fw-3.4.16.3435
cntrl-4.8.15  fw-3.4.17.3440
