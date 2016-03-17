#Objective
Run Unifi Controller on Red Hat Enterpries Linux.  Branched from jacobalberty and rednut.

## Background
I've been a long-time RHEL user, and recently became a Ubiquity (UBNT) customer.  I purchased two UAP-AC-PRO to improve the WiFi situation at home.  I deployed one unit upstairs, and the other unit in the basement to provide complete coverage.

## Description 
This is a containerized version of the Unifi Access Point controller.
I would prefer to not use --net=host because it exposes D-BUS, and rouge stuff could reboot my host.

I need to provide my firewalld rules (/etc/firewalld/services) and systemd (not done yet.)

See commands.txt for examples
Use `sudo docker build -t home.lab/unifi:4.8.14 . | tee ./docker-build.log` to begin...
Followed by `sudo docker run --name=unifi -p 3478:3478/udp -p 8080:8080/tcp -p 8443:8443/tcp -d home.lab/unifi:4.8.14`

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

## Expose (required):
*3478 - UDP STUN
*8080 - inform (AP -> Controller)
*8443 - WebUI of Controller
## Expose (optional):
*27117 - mongodb (not recommended)
*8843 - Portal HTTPS
*8880 - Portal

