#!/bin/bash
clear
echo "This script assumes Plex Media Server is installed."
echo "Now downloading Plex Trakt Scrobbler..."
sleep 2

# Downloading Plex-Trakt-Scrobbler
cd /tmp
wget https://github.com/trakt/Plex-Trakt-Scrobbler/archive/master.zip -O Plex-Trakt-Scrobbler.zip
clear
echo "Trakt downloaded"
unzip /tmp/Plex-Trakt-Scrobbler.zip > /dev/null
sudo cp -r Plex-Trakt-Scrobbler-*/Trakttv.bundle "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-ins/"
echo "Trakt installed"

# Downloading apsw.so and trakt databases
wget https://www.dropbox.com/s/jo9jam8n73htkqc/trakt.zip?dl=1 -O trakt.zip
unzip trakt.zip > /dev/null

# Changing ownership and copying databases
sudo chown plex:plex /tmp/trakt/com.plexapp.plugins.trakttv.db
sudo chown plex:plex /tmp/trakt/com.plexapp.plugins.trakttv.db-shm
sudo chown plex:plex /tmp/trakt/com.plexapp.plugins.trakttv.db-wal
sudo chmod u=rw,g=r,o=r /tmp/trakt/com.plexapp.plugins.trakttv.db
sudo chmod u=rw,g=r,o=r /tmp/trakt/com.plexapp.plugins.trakttv.db-shm
sudo chmod u=rw,g=r,o=r /tmp/trakt/com.plexapp.plugins.trakttv.db-wal
sudo cp /tmp/trakt/apsw.so /usr/lib/plexmediaserver/Resources/Python/lib/python2.7/lib-dynload
sudo cp /tmp/trakt/com.plexapp.plugins.trakttv.db "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
sudo cp /tmp/trakt/com.plexapp.plugins.trakttv.db-shm "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
sudo cp /tmp/trakt/com.plexapp.plugins.trakttv.db-wal "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
echo "Moved databases"
sleep 3

sudo systemctl restart plexmediaserver
echo "Restarted Plex"
sleep 2
echo "Completed"
