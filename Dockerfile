FROM lsiobase/ubuntu:focal

MAINTAINER edifus <edifus@gmail.com>

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV PYTHON_EGG_CACHE="/config/plugins/.python-eggs"
ENV HOME="/config"

ARG FILEBOT_VERSION="4.9.2"
ARG FILEBOT_PACKAGE="FileBot_${FILEBOT_VERSION}_universal.deb"

# install software
RUN \
 apt-get update && \
 apt-get install -y gnupg && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C5E6A5ED249AD24C && \
 echo "deb http://ppa.launchpad.net/deluge-team/ppa/ubuntu bionic main" >> /etc/apt/sources.list.d/deluge.list && \
 echo "deb-src http://ppa.launchpad.net/deluge-team/stable/ubuntu bionic main" >> /etc/apt/sources.list.d/deluge.list && \
 apt-get update && \
 apt-get install -y deluged=1.3.15-1~zesty~ppa2 deluge-console=1.3.15-1~zesty~ppa2 deluge-web=1.3.15-1~zesty~ppa2 \
                    p7zip-full unrar unzip \
                    mediainfo libchromaprint-tools \
                    inotify-tools \
                    openjdk-11-jre-headless libjna-java && \
 curl -L -O https://get.filebot.net/filebot/FileBot_${FILEBOT_VERSION}/${FILEBOT_PACKAGE} && \
 dpkg -i ${FILEBOT_PACKAGE} && \
 rm ${FILEBOT_PACKAGE} && \
 apt-get autoclean -y && \
 apt-get autoremove --purge -y && \
 rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# add local files
COPY root/ /

# volumes
VOLUME /config
