FROM registry.access.redhat.com/rhel7:latest
MAINTAINER John Call <johnsimcall@gmail.com>
LABEL com.ubnt.controller="5.6.22-1"

ADD https://dl.ubnt.com/unifi/5.6.22/UniFi.unix.zip /opt/UniFi/

# https://help.ubnt.com/hc/en-us/articles/204911424-UniFi-Remove-prune-older-data-and-adjust-mongo-database-size
ADD https://help.ubnt.com/hc/article_attachments/115024095828/mongo_prune_js.js /opt/UniFi/
ADD shutdown-unifi.sh /opt/UniFi/

RUN ln -f -s /usr/share/zoneinfo/America/Denver /etc/localtime && \
    useradd unifi --comment "UniFi Controller" --uid 201 --system --home-dir /opt/UniFi/ && \
    yum clean all && \
    yum -y --disablerepo="*" \
      --enablerepo=rhel-7-server-rpms \
      --enablerepo=rhel-server-rhscl-7-rpms \
      install unzip java-1.8.0-openjdk-headless rh-mongodb34-mongodb rh-mongodb34-mongodb-server && \
    ln -s /opt/rh/rh-mongodb34/root/usr/bin/mongod /usr/bin/mongod && \
    unzip -d /opt/ /opt/UniFi/UniFi.unix.zip && \
    mkdir /opt/UniFi/data && mkdir /opt/UniFi/logs && chown -Rv unifi:unifi /opt/UniFi/ && \
    yum clean all && rm -rvf /var/cache/yum /opt/UniFi/UniFi.unix.zip

VOLUME ["/opt/UniFi/data"]
VOLUME ["/opt/UniFi/logs"]
WORKDIR /opt/UniFi
EXPOSE 8443/tcp 8080/tcp 3478/udp 27117/tcp
USER unifi
ENV TERM=xterm-256color

# /usr/bin/scl enable rh-mongodb34 -- /usr/bin/java -Xmx1024M -jar lib/ace.jar start
ENTRYPOINT ["/usr/bin/scl", "enable", "rh-mongodb34", "--"]
CMD ["/usr/bin/java", "-Xmx1024M", "-jar", "lib/ace.jar", "start"]

# ---- Notes and TODO ----
# Capture the output (stdout/stderr?) from java -jar ... to a file
# http://stackoverflow.com/questions/21098382/bash-how-to-add-timestamp-while-redirecting-stdout-to-file
# java -jar ... | awk '{ print strftime("%c: "), $0; fflush(); }' | tee logs/java-output.log
