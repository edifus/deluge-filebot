FROM lsiobase/ubuntu:xenial

MAINTAINER edifus <edifus@gmail.com>

# environment variables
ENV \
 HOME="/config" \
 PYTHON_EGG_CACHE="/config/plugins/.python-eggs" \
 DEBIAN_FRONTEND=noninteractive

ARG FILEBOT_VERSION="4.7.9"
ARG FILEBOT_PACKAGE="filebot_${FILEBOT_VERSION}_amd64.deb"

# copy sources
COPY sources.list /etc/apt/

RUN \
 echo "**** configure apt repos ****" && \
 apt-get update && \
 apt-get -y install --no-install-recommends software-properties-common && \
 add-apt-repository ppa:deluge-team/ppa && \
 apt-get update && \
 apt-get -y install --no-install-recommends deluged deluge-web deluge-console mediainfo libchromaprint-tools inotify-tools openjdk-8-jre-headless && \
 curl -L -O https://downloads.sourceforge.net/project/filebot/filebot/FileBot_${FILEBOT_VERSION}/${FILEBOT_PACKAGE} && \
 dpkg -i ${FILEBOT_PACKAGE} && \
 rm ${FILEBOT_PACKAGE} && \
 apt-get clean && \
 rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# add linuxserver.io files
COPY root/ /

# ports and volumes
EXPOSE 8112 58846 58946 58946/udp
VOLUME /config

# init
ENTRYPOINT ["/init"]
