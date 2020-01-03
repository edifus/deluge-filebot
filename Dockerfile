FROM lsiobase/ubuntu:bionic

MAINTAINER edifus <edifus@gmail.com>

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV PYTHON_EGG_CACHE="/config/plugins/.python-eggs"

ARG FILEBOT_VERSION="4.7.9"
ARG FILEBOT_PACKAGE="filebot_${FILEBOT_VERSION}_amd64.deb"

# install software
RUN \
 echo "**** add repositories ****" && \
 apt-get update && \
 apt-get install -y \
	gnupg && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C5E6A5ED249AD24C && \
 echo "deb http://ppa.launchpad.net/deluge-team/stable/ubuntu bionic main" >> \
	/etc/apt/sources.list.d/deluge.list && \
 echo "deb-src http://ppa.launchpad.net/deluge-team/stable/ubuntu bionic main" >> \
	/etc/apt/sources.list.d/deluge.list && \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
	deluged \
	deluge-console \
	deluge-web \
	p7zip-full \
	unrar \
	unzip \
	mediainfo \
	libchromaprint-tools \
	inotify-tools \
	openjdk-8-jre-headless && \
 curl -L -O https://downloads.sourceforge.net/project/filebot/filebot/FileBot_${FILEBOT_VERSION}/${FILEBOT_PACKAGE} && \
	dpkg -i ${FILEBOT_PACKAGE} && \
	rm ${FILEBOT_PACKAGE} && \
 echo "**** cleanup ****" && \
 apt-get autoclean -y && \
 apt-get autoremove --purge -y && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8112 58846 58946 58946/udp
VOLUME /config /downloads
