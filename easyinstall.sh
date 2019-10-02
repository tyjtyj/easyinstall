#!/bin/bash
echo "This script will download and install:"
echo "Plex (via it's official repository)"
sleep 1
echo "qBittorrent"
sleep 1
echo "Pi-Hole"

echo "Downloading and installing available updates"
sudo apt-get update && sudo apt-get upgrade -y > /dev/null
echo "All updates installed successfully"

echo "Now downloading Plex"
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list > /dev/null
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add - > /dev/null
sudo apt-get update && sudo apt-get install plexmediaserver -y > /dev/null
echo "Plex installed successfully"

echo "Now downloading qBittorrent"


echo "Now installing Pi-Hole"
curl -sSL https://install.pi-hole.net | bash
