FROM lsiobase/ubuntu:bionic

MAINTAINER edifus <edifus@gmail.com>

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV PYTHON_EGG_CACHE="/config/plugins/.python-eggs"
ENV HOME="/config"

ARG FILEBOT_VERSION="4.9.2"
ARG FILEBOT_PACKAGE="FileBot_${FILEBOT_VERSION}_universal.deb"

ARG MEDIAINFO_VERSION="20.09"
ARG LIBZEN_VERSION="0.4.38"
ARG MEDIAINFO_PACKAGE="mediainfo_${MEDIAINFO_VERSION}-1_amd64.xUbuntu_18.04.deb"
ARG LIBMEDIAINFO_PACKAGE="libmediainfo0v5_${MEDIAINFO_VERSION}-1_amd64.xUbuntu_18.04.deb"
ARG LIBZEN_PACKAGE="libzen0v5_${LIBZEN_VERSION}-1_amd64.xUbuntu_18.04.deb"

# install software
RUN \
 apt-get update && \
 apt-get install -y gnupg && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C5E6A5ED249AD24C && \
 echo "deb http://ppa.launchpad.net/deluge-team/ppa/ubuntu bionic main" >> /etc/apt/sources.list.d/deluge.list && \
 echo "deb-src http://ppa.launchpad.net/deluge-team/stable/ubuntu bionic main" >> /etc/apt/sources.list.d/deluge.list && \
 apt-get update && \
 apt-get install -y deluged deluge-console deluge-web \
                    p7zip-full unrar unzip \
                    libchromaprint-tools inotify-tools libcurl3-gnutls libmms0 \
                    openjdk-11-jre-headless libjna-java && \
 curl -L -O https://get.filebot.net/filebot/FileBot_${FILEBOT_VERSION}/${FILEBOT_PACKAGE} && \
 curl -L -O https://mediaarea.net/download/binary/mediainfo/${MEDIAINFO_VERSION}/${MEDIAINFO_PACKAGE} && \
 curl -L -O https://mediaarea.net/download/binary/libmediainfo0/${MEDIAINFO_VERSION}/${LIBMEDIAINFO_PACKAGE} && \
 curl -L -O https://mediaarea.net/download/binary/libzen0/${LIBZEN_VERSION}/${LIBZEN_PACKAGE} && \
 dpkg -i ${LIBZEN_PACKAGE} ${LIBMEDIAINFO_PACKAGE} ${MEDIAINFO_PACKAGE} ${FILEBOT_PACKAGE} && \
 rm ${FILEBOT_PACKAGE} ${LIBZEN_PACKAGE} ${LIBMEDIAINFO_PACKAGE} ${MEDIAINFO_PACKAGE} && \
 apt-get autoclean -y && \
 apt-get autoremove --purge -y && \
 rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# add local files
COPY root/ /

# volumes
VOLUME /config
