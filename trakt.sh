#!/bin/bash
clear
echo "Now downloading Plex Trakt Scrobbler"
echo "."
echo "Changing working directory to /tmp"
cd /tmp
wget https://github.com/trakt/Plex-Trakt-Scrobbler/archive/master.zip -O Plex-Trakt-Scrobbler.zip > /dev/null 2>&1
echo "Trakt downloaded"
unzip Plex-Trakt-Scrobbler.zip > /dev/null 2>&1
sudo cp -r Plex-Trakt-Scrobbler-*/Trakttv.bundle "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-ins/"
echo "."
echo "Trakt installed"
sudo rm -r Plex-Trakt-Scrobbler.zip
sudo rm -r Plex-Trakt-Scrobbler-*
wget https://www.dropbox.com/s/jo9jam8n73htkqc/trakt.zip?dl=1 -O trakt.zip > /dev/null 2>&1
unzip trakt.zip > /dev/null 2>&1
cd trakt
sudo mv apsw.so /usr/lib/plexmediaserver/Resources/Python/lib/python2.7/lib-dynload
echo "Moved apsw.so"
sudo chown plex:plex com.plexapp.plugins.trakttv.db
sudo chown plex:plex com.plexapp.plugins.trakttv.db-shm
sudo chown plex:plex com.plexapp.plugins.trakttv.db-wal
sudo mv com.plexapp.plugins.trakttv.db "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
sudo mv com.plexapp.plugins.trakttv.db-shm "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
sudo mv com.plexapp.plugins.trakttv.db-wal "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
echo "Moved databases"
echo "."
sudo systemctl restart plexmediaserver > /dev/null 2>&1
echo "Restarted Plex"
echo "Completed"
echo "Now manually delete the 'trakt' folder"
