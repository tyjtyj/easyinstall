#!/bin/bash

clear
printf "Now downloading qBittorrent..."
sleep 2
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
sudo apt-get update > /dev/null
sudo apt-get install qbittorrent-nox -y > /dev/null
printf "Installed"
clear
echo "Install qbittorrent.service? (y/N)?"
read query
if [ $query = "y" ]
then
  cd /tmp
  wget https://raw.githubusercontent.com/agneevX/easyinstall/master/qbittorrent.service -O qbittorrent.service
  sed -i "s/qbtuser/$USER/g" /tmp/qbittorrent.service
  sudo cp /tmp/qbittorrent.service /etc/systemd/system
  sudo systemctl enable qbittorrent.service
  sudo systemctl start qbittorrent.service
  exit 0
else
  exit 1
fi
if [ $? -eq 0 ]
then
  printf "qBittorrent installed and running at port 8080"
  printf "username: admin, password: adminadmin"
elif [ $? -eq 1 ]
then
  printf "qBittorrent installed"
  printf "username: admin, password: adminadmin"
fi
