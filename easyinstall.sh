#!/bin/bash
set -e
clear

echo "This script will download and install:"
echo "Plex (via it's official repository) with Trakt"
echo "Rclone"
echo "qBittorrent"
echo "Pi-Hole"
sleep 2

clear
echo "Downloading and installing available updates"
sleep 2
sudo apt-get update > /dev/null
sudo apt-get upgrade -y > /dev/null
echo "All updates installed successfully"
sleep 2

clear
echo "Now downloading Plex"
sleep 2
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
sleep 1
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
sudo apt-get update > /dev/null
sudo apt-get install plexmediaserver -y > /dev/null
clear
echo "Plex installed successfully"
sleep 2
echo "Now downloading Plex Trakt Scrobbler"
sleep 2
cd /tmp
wget https://github.com/trakt/Plex-Trakt-Scrobbler/archive/master.zip -O Plex-Trakt-Scrobbler.zip > /dev/null
clear
echo "Trakt downloaded"
sudo apt-get install unzip -y > /dev/null
clear
echo "Unzipping downloaded archive"
unzip Plex-Trakt-Scrobbler.zip > /dev/null
sudo cp -r Plex-Trakt-Scrobbler-*/Trakttv.bundle "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-ins/"
clear
echo "Trakt installed"

#Downloading apsw.so and trakt databases
wget https://www.dropbox.com/s/jo9jam8n73htkqc/trakt.zip?dl=1 -O trakt.zip > /dev/null
unzip trakt.zip > /dev/null
cd trakt

#Changing ownership 
sudo chown root:root com.plexapp.plugins.trakttv.db
sudo chown root:root com.plexapp.plugins.trakttv.db-shm
sudo chown root:root com.plexapp.plugins.trakttv.db-wal

sudo mv apsw.so /usr/lib/plexmediaserver/Resources/Python/lib/python2.7/lib-dynload
clear
echo "Moved apsw.so"
sudo mv com.plexapp.plugins.trakttv.db "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
sudo mv com.plexapp.plugins.trakttv.db-shm "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
sudo mv com.plexapp.plugins.trakttv.db-wal "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
clear
echo "Moved databases"
sleep 2
sudo systemctl restart plexmediaserver
clear
echo "Restarted Plex"
sleep 2

clear
echo "Now downloading Rclone"
sleep 2
curl https://rclone.org/install.sh | sudo bash
cd /tmp
wget https://raw.githubusercontent.com/muskingo/easyinstall/master/media.service -O media.service > /dev/null
sudo cp media.service /etc/systemd/system/
sudo systemctl enable media.service
clear
echo "Copied media.service"
echo "After this script finishes, set up rclone using rclone config"
sleep 1

clear
echo "Now downloading qBittorrent"
sleep 1
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
sleep 1
sudo apt-get update
sudo apt-get install qbittorrent-nox -y
cd /tmp && wget https://raw.githubusercontent.com/muskingo/easyinstall/master/qbittorrent.service -O qbittorrent.service
clear
echo "Change user and group to the suitable one"
sleep 1
sudo nano qbittorrent.service
sudo cp qbittorrent.service /etc/systemd/system
sudo systemctl enable qbittorrent.service
sudo systemctl start qbittorrent.service
clear
echo "qBittorrent installed and running at port 8080"
echo "username: admin, password: adminadmin"
sleep 3

sudo systemctl daemon-reload

clear
echo "Now installing Pi-Hole"
sleep 2
curl -sSL https://install.pi-hole.net | bash

sudo reboot
