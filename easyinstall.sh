#!/bin/bash
clear

echo "This script will download and install:"
echo "Plex (via it's official repository) with Trakt"
sleep 1
echo "Rclone"
sleep 1
echo "qBittorrent"
sleep 1
echo "Pi-Hole"

echo "Downloading and installing available updates"
sleep 2
sudo apt-get update && sudo apt-get upgrade -y
echo "All updates installed successfully"
sleep 2

echo "Now downloading Plex"
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list > /dev/null
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add - > /dev/null
sudo apt-get update && sudo apt-get install plexmediaserver -y > /dev/null
echo "Plex installed successfully"
#Installing Plex-Trakt-Scrobbler using the trakt.sh script
cd /tmp && wget https://raw.githubusercontent.com/muskingo/easyinstall/master/trakt.sh -O trakt.sh > /dev/null
sudo chmod a+rx trakt.sh
./trakt.sh

echo "Now downloading Rclone"
sleep 2
curl https://rclone.org/install.sh | sudo bash
cd /tmp && wget https://raw.githubusercontent.com/muskingo/easyinstall/master/media.service -O media.service > /dev/null
sudo cp media.service /etc/systemd/system/
sudo systemctl enable media.service
echo "Copied media.service"
echo "After this script finishes, set up rclone using rclone config"
sleep 1

echo "Now downloading qBittorrent"
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable > /dev/null
sudo apt-get update && sudo apt-get install qbittorrent-nox -y > /dev/null
sudo adduser qbtuser --defaults
cd /tmp && wget https://raw.githubusercontent.com/muskingo/easyinstall/master/qbittorrent.service -O qbittorrent.service > /dev/null
sudo cp qbittorrent.service /etc/systemd/system
sudo systemctl enable qbittorrent.service
sudo systemctl start qbittorrent.service
echo "qBittorrent installed and running at port 8080"
echo "username: admin, password: adminadmin"
sleep 3

sudo systemctl daemon-reload

echo "Now installing Pi-Hole"
curl -sSL https://install.pi-hole.net | bash

sudo reboot
