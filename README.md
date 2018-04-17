# deluge-filebot

Based on linuxserver.io ubuntu base and their deluge container. Added Java and Filebot for FilebotTool plugin support.

* Mount downloads to /downloads or /mnt/downloads, or /data/downlaods.. etc
* Environment variables are same as linuxserver.io Deluge container; PUID, GUID, TZ, UMASK_SET
    
    example:
    docker run -d --name deluge --restart=unless-stopped \
     -e PUID=1000 -e PGID=1000 -e TZ=UTC -e UMASK_SET=002 \
     -v /path/to/downloads:/downloads -v /path/to/config:/config \
     edifus/deluge-filebot
