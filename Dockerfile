FROM lsiobase/ubuntu:xenial

MAINTAINER edifus <edifus@gmail.com>

# environment variables
ENV \
 HOME="/config" \
 JAVA_HOME="/usr/lib/jvm/java-8-oracle" \
 PYTHON_EGG_CACHE="/config/plugins/.python-eggs"

ARG JAVA_VERSION="8"
ARG FILEBOT_VERSION="4.7.9"
ARG FILEBOT_SHA256="892723dcec8fe5385ec6665db9960e7c1a88e459a60525c02afb7f1195a50523"
ARG FILEBOT_PACKAGE="filebot_${FILEBOT_VERSION}_amd64.deb"

# copy sources
COPY sources.list /etc/apt/

RUN \
 echo "**** configure apt repos ****" && \
 echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main' >> /etc/apt/sources.list && \
 echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main' >> /etc/apt/sources.list && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886 && \
 apt-get update && \
 apt-get -y install --no-install-recommends software-properties-common && \
 add-apt-repository ppa:deluge-team/ppa && \
 apt-get update && \

# install deluge
 echo "**** install deluge ****" && \
 apt-get -y install --no-install-recommends deluged deluge-web deluge-console mediainfo libchromaprint-tools inotify-tools && \

# install filebot
 echo "**** install filebot ****" && \
 curl -L -O https://downloads.sourceforge.net/project/filebot/filebot/FileBot_${FILEBOT_VERSION}/${FILEBOT_PACKAGE} && \
 echo "${FILEBOT_SHA256} *${FILEBOT_PACKAGE}" | sha256sum --check --strict && \
 dpkg -i ${FILEBOT_PACKAGE} && \
 rm ${FILEBOT_PACKAGE} && \

# install java
 echo "**** install java8 ****" && \
 echo oracle-java${JAVA_VERSION}-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
 apt-get install -y --no-install-recommends oracle-java${JAVA_VERSION}-installer oracle-java${JAVA_VERSION}-set-default && \
 update-java-alternatives -s java-8-oracle && \
 echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /etc/bash.bashrc && \

# cleanup
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /var/cache/oracle-jdk${JAVA_VERSION}-installer

# add linuxserver.io files
COPY root/ /

# ports and volumes
EXPOSE 8112 58846 58946 58946/udp
VOLUME /config

# init
ENTRYPOINT ["/init"]
