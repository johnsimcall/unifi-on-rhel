FROM registry.access.redhat.com/rhel7:latest
MAINTAINER John Call <johnsimcall@gmail.com>
LABEL com.ubnt.controller="5.4.18"

# https://help.ubnt.com/hc/en-us/articles/204911424-UniFi-Remove-prune-older-data-and-adjust-mongo-database-size
ADD https://help.ubnt.com/hc/en-us/article_attachments/204082688/mongo_prune_js.js /opt/UniFi/
ADD https://www.ubnt.com/downloads/unifi/5.4.18/UniFi.unix.zip /opt/UniFi/
ADD shutdown-unifi.sh /opt/UniFi/

RUN useradd unifi --comment "UniFi Controller" --uid 201 --system --home-dir /opt/UniFi/ && \
    chown -Rv unifi:unifi /opt/UniFi/
RUN yum clean all && \
    yum -y --disablerepo="*" \
      --enablerepo=rhel-7-server-rpms \
      --enablerepo=rhel-7-server-thirdparty-oracle-java-rpms \
      --enablerepo=rhel-server-rhscl-7-rpms \
      install unzip java-1.8.0-oracle rh-mongodb26-mongodb-server && \
    yum clean all
RUN ln -s /opt/rh/rh-mongodb26/root/usr/bin/mongod /usr/bin/mongod

USER unifi
RUN unzip -d /opt/ /opt/UniFi/UniFi.unix.zip && rm /opt/UniFi/UniFi.unix.zip

# You can mount a local path into the container by supplying the `-v` argument like
# `-v <local_path>:<container_path>:z` e.g. `-v /nas/docker-host-mounts/UniFi/data:/opt/UniFi/data:z`
# Don't forget the trailing ":z" on the mount for SELinux
VOLUME ["/opt/UniFi/data"]
VOLUME ["/opt/UniFi/logs"]
WORKDIR /opt/UniFi
ENV TZ=UTC
ENV TERM=xterm-256color
EXPOSE 8080/tcp 8443/tcp 3478/udp
ENTRYPOINT ["/usr/bin/scl", "enable", "rh-mongodb26", "--"]
CMD ["/usr/bin/java", "-Xmx1024M", "-jar", "lib/ace.jar", "start"]



# ---- Notes and TODO ----
#
# Capture the output (stdout/stderr?) from java -jar ... to a file
# http://stackoverflow.com/questions/21098382/bash-how-to-add-timestamp-while-redirecting-stdout-to-file
# java -jar ... | awk '{ print strftime("%c: "), $0; fflush(); }' | tee logs/java-output.log

# ---- Firewall info ----
# 27117 - mongodb (loopback only)
# 3478 - UDP STUN
# 8080 - inform (AP -> Controller)
# 8443 - WebUI of Controller
# 8843 - Portal HTTPS
# 8880 - Portal
