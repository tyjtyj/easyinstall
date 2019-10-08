#!/bin/bash -x
# set -e
clear

echo "This script will download and install:"
echo "Plex (via it's official repository) with Trakt"
echo "Rclone"
echo "qBittorrent"
printf "Pi-Hole\n"

echo "Downloading and installing available updates..."
sudo apt update > /dev/null
sudo apt upgrade -y > /dev/null
echo "All updates installed successfully"

read -p -n1 "Install Plex? (y/N)" input
if [ $input = "y" ]
then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/plex.sh | sudo bash
else
  echo "Skipping Plex installation"
fi

read -p -n1 "Install Plex-trakt-scrobbler? (y/N)?" input
if [ $input = "y" ]
then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/trakt.sh | sudo bash
else
  echo "Skipping Plex-Trakt-Scrobbler installation"
fi

clear
read -p -n1 "Install Rclone? (y/N)?" input
if [ $input = "y" ]
then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/rclone.sh | sudo bash
else
  echo "Not installing Rclone."
fi

read -p -n1 "Install qBittorrent? (y/N)" input
if [ $input = "y" ]
then
  # qBittorrent un-official install scipt
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/qbittorrent.sh | sudo bash
else
  echo "Not installing qBittorrent"
fi

sudo systemctl daemon-reload
read -p -n1 "Install Pi-Hole? (y/N)" input
if [ $input = "y" ]
then
  clear
  echo "Now installing Pi-hole"
  # Pi-hole install script
  curl -sSL https://install.pi-hole.net | bash
else
  echo "Not installing Pi-hole"
fi

read -p -n1 "Reboot system? (y/N)" input
if [ $input = "y" ]
then
  echo "System rebooting in 3"
  sleep 3
  sudo reboot
else
  echo "Not rebooting"
fi
echo "Exiting script..."
