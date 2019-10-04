#!/bin/bash
clear

echo "This script assumes Plex is installed"
sleep 1
echo "Press Control-C now to stop this script if it's not installed"
sleep 2
echo "Now downloading Plex Trakt Scrobbler"
sleep 2
echo "Changing working directory to /tmp"


# Downloading Plex-Trakt-Scrobbler
cd /tmp
wget https://github.com/trakt/Plex-Trakt-Scrobbler/archive/master.zip -O Plex-Trakt-Scrobbler.zip
clear
echo "Trakt downloaded"
unzip Plex-Trakt-Scrobbler.zip > /dev/null
sudo cp -r Plex-Trakt-Scrobbler-*/Trakttv.bundle "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-ins/"
echo "Trakt installed"

#Downloading apsw.so and trakt databases
wget https://www.dropbox.com/s/jo9jam8n73htkqc/trakt.zip?dl=1 -O trakt.zip
unzip trakt.zip > /dev/null

#Changing ownership 
sudo chown plex:plex /tmp/trakt/com.plexapp.plugins.trakttv.db
sudo chown plex:plex /tmp/trakt/com.plexapp.plugins.trakttv.db-shm
sudo chown plex:plex /tmp/trakt/com.plexapp.plugins.trakttv.db-wal
sudo chmod u=rw,g=r,o=r /tmp/trakt/com.plexapp.plugins.trakttv.db
sudo chmod u=rw,g=r,o=r /tmp/trakt/com.plexapp.plugins.trakttv.db-shm
sudo chmod u=rw,g=r,o=r /tmp/trakt/com.plexapp.plugins.trakttv.db-wal

sudo cp apsw.so /usr/lib/plexmediaserver/Resources/Python/lib/python2.7/lib-dynload
echo "Moved apsw.so"
sudo cp /tmp/trakt/com.plexapp.plugins.trakttv.db "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
sudo cp /tmp/trakt/com.plexapp.plugins.trakttv.db-shm "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
sudo cp /tmp/trakt/com.plexapp.plugins.trakttv.db-wal "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
echo "Moved databases"
sleep 3

sudo systemctl restart plexmediaserver
echo "Restarted Plex"
echo "Completed"

echo "Rebooting systemc within 5"
sleep 5
sudo reboot
