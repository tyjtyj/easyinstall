#!/bin/bash -x
# set -e
clear

echo "This script will download and install:"
echo "Plex (via it's official repository) with Trakt-scrobbler"
printf "Rclone\nqBittorrent\nPi-Hole\nSonarr\nRadarr\nPihole\nrTorrent+Flood\n\n"
sleep 3

echo "Downloading and installing available updates..."
sleep 2
sudo apt update
sudo apt upgrade -y
echo "All updates installed successfully"
sleep 2

read -p -r -n1 "Install Plex? (y/N)" input
if [[ $input == "Y" || $input == "y" ]]; then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/template_plex.sh | sudo bash
else
  echo "Skipping Plex installation"
fi

read -p -r -n1 "Install Plex-trakt-scrobbler? (y/N)" input
if [[ $input == "Y" || $input == "y" ]]; then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/trakt.sh | sudo bash
else
  echo "Skipping Plex-Trakt-Scrobbler installation"
fi

read -p -r -n1 "Install Sonarr? (y/N)" input
if [[ $input == "Y" || $input == "y" ]]; then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/sonarr.sh | sudo bash
else
  echo "Skipping Sonarr installation"
fi

read -p -r -n1 "Install Radarr? (y/N)" input
if [[ $input == "Y" || $input == "y" ]]; then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/radarr.sh | sudo bash
else
  echo "Skipping Radarr installation"
fi

read -p -r -n1 "Install Rclone? (y/N)" input
if [[ $input == "Y" || $input == "y" ]]; then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/rclone.sh | sudo bash
else
  echo "Not installing Rclone."
fi

read -p -r -n1 "Install rTorrent+Flood? (y/N)" input
if [[ $input == "Y" || $input == "y" ]]; then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/rtorrent/rtorrent_flood.sh | sudo bash
else
  echo "Not installing rTorrent+Flood."
fi

read -p -r -n1 "Install qBittorrent? (y/N)" input
if [[ $input == "Y" || $input == "y" ]]; then
  # qBittorrent un-official install scipt
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/qbittorrent.sh | sudo bash
else
  echo "Not installing qBittorrent"
fi

read -p -r -n1 "Install Pi-Hole? (y/N)" input
if [[ $input == "Y" || $input == "y" ]]; then
  clear
  echo "Now installing Pi-hole"
  # Pi-hole install script
  curl -sSL https://install.pi-hole.net | bash
else
  echo "Not installing Pi-hole"
fi

read -p -r -n1 "Reboot system? (y/N)" input
if [[ $input == "Y" || $input == "y" ]]; then
  echo "System rebooting in 3"
  sleep 3
  sudo reboot
else
  echo "Not rebooting"
fi
echo "Exiting script..."
exit 0
