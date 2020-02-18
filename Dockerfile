FROM lsiobase/ubuntu:bionic

MAINTAINER edifus <edifus@gmail.com>

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV PYTHON_EGG_CACHE="/config/plugins/.python-eggs"
ENV HOME="/config"

ARG FILEBOT_VERSION="4.7.9"
ARG FILEBOT_PACKAGE="filebot_${FILEBOT_VERSION}_amd64.deb"

# install software
RUN \
 apt-get update && \
 apt-get install -y \
	gnupg && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C5E6A5ED249AD24C && \
 echo "deb http://ppa.launchpad.net/deluge-team/ppa/ubuntu bionic main" >> \
	/etc/apt/sources.list.d/deluge.list && \
 apt-get update && \
 apt-get install -y \
	deluged deluge-console deluge-web \
	p7zip-full unrar unzip \
	mediainfo libchromaprint-tools inotify-tools \
	openjdk-8-jre-headless && \
 curl -L -O https://downloads.sourceforge.net/project/filebot/filebot/FileBot_${FILEBOT_VERSION}/${FILEBOT_PACKAGE} && \
	dpkg -i ${FILEBOT_PACKAGE} && \
	rm ${FILEBOT_PACKAGE} && \
 apt-get autoclean -y && \
 apt-get autoremove --purge -y && \
 rm -rf /tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# volumes
VOLUME /config /downloads
