FROM registry.access.redhat.com/rhel7:latest
MAINTAINER John Call <johnsimcall@gmail.com>
LABEL com.ubnt.controller="4.8.14"

# wget http://dl.ubnt.com/unifi/4.8.14/UniFi.unix.zip | manually extract ZIP and create TAR archive instead
# consider changing this to a wget/curl | unzip --if unzip exists in image...--
ADD Unifi-4_8_14.tgz /opt/

# https://help.ubnt.com/hc/en-us/articles/204911424-UniFi-Remove-prune-older-data-and-adjust-mongo-database-size
ADD https://help.ubnt.com/hc/en-us/article_attachments/204082688/mongo_prune_js.js /opt/UniFi/

RUN yum -y --disablerepo="*" \
 --enablerepo=rhel-7-server-rpms \
 --enablerepo=rhel-7-server-thirdparty-oracle-java-rpms \
 --enablerepo=rhel-server-rhscl-7-rpms \
 install java-1.8.0-oracle rh-mongodb26-mongodb-server && \
 yum clean all

RUN ln -s /opt/rh/rh-mongodb26/root/usr/bin/mongod /usr/bin/mongod

EXPOSE 8080/tcp 8443/tcp 3478/udp
#VOLUME ["/var/lib/unifi", "/var/log/unifi", "/var/run/unifi", "/usr/lib/unifi/work"]
WORKDIR /opt/UniFi
ENV TZ=UTC

ENTRYPOINT ["/usr/bin/scl", "enable", "rh-mongodb26", "--"]
CMD ["/usr/bin/java", "-Xmx1024M", "-jar", "lib/ace.jar", "start"]


# ---- Notes and TOD ----
# http://stackoverflow.com/questions/21098382/bash-how-to-add-timestamp-while-redirecting-stdout-to-file
# Capture the output (stdout/stderr?) from java -jar ... to a file
# java -jar ... | awk '{ print strftime("%c: "), $0; fflush(); }' | tee logs/java-output.log

# 27117 - mongodb (loopback only)
# 3478 - UDP STUN
# 8080 - inform (AP -> Controller)
# 8443 - WebUI of Controller
# 8843 - Portal HTTPS
# 8880 - Portal

## Run as user nobody, but I don't know for sure that all features work
#RUN chown -R nobody.nogroup /usr/lib/unifi
#RUN chown -R nobody.nogroup /var/lib/unifi
#RUN chown -R nobody.nogroup /var/log/unifi
#RUN chown -R nobody.nogroup /var/run/unifi
#USER nobody
##
## alternate
##
#RUN useradd xyz
