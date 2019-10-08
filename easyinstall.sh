#!/bin/bash -x
# set -e
clear

IP_ADDRESS=$(ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

echo "This script will download and install:"
echo "Plex (via it's official repository) with Trakt"
echo "Rclone"
echo "qBittorrent"
echo "Pi-Hole"

clear
echo "Downloading and installing available updates..."
sudo apt-get update > /dev/null
sudo apt-get upgrade -y > /dev/null
echo "All updates installed successfully"

echo "Install Plex? (y/N)"
read input
if [[ $input = "y" ]]
then
  wget https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/plex.sh
  sudo bash plex.sh
else
  echo "Skipping Plex installation"
fi

echo "Install Plex-trakt-scrobbler? (y/N)?"
read input
if [ $input = "y" ]
then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/trakt.sh
  sudo bash trakt.sh
else
  echo "Skipping Plex-Trakt-Scrobbler installation"
fi

clear
echo "Install Rclone? (y/N)?"
read input
if [ $input = "y" ]
then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/rclone.sh
  sudo bash rclone.sh
else
  echo "Not installing Rclone."
fi
sleep 3
echo "Install qBittorrent? (y/N)"
read input
if [ $input = "y" ]
then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/qbittorrent.sh
  sudo bash qbittorrent.sh
else
  echo "Not installing qBittorrent"
fi

sudo systemctl daemon-reload
clear
echo "Install Pi-Hole? (y/N)"
read input
if [ $input = "y" ]
then
  clear
  echo "Now installing Pi-hole"
  # Pi-hole install script
  curl -sSL https://install.pi-hole.net | bash
else
  echo "Not installing Pi-hole"
fi

echo "Reboot system? (y/N)"
if [ $input = "y" ]
read input
then
  echo "System rebooting in 3"
  sleep 3
  sudo reboot
else
  echo "Not rebooting"
fi
echo "Exiting script..."
