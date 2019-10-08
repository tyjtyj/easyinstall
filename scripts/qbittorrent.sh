#!/bin/bash

clear
echo "Now downloading qBittorrent..."
sleep 2
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
sudo apt-get update > /dev/null
sudo apt-get install qbittorrent-nox -y > /dev/null
echo "Installed"
clear
echo "Install qbittorrent.service? (y/N)?"
read input
if [ "$input" = "y" ]
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
  echo "qBittorrent installed and running at port 8080"
  echo "username: admin, password: adminadmin"
elif [ $? -eq 1 ]
then
  echo "qBittorrent installed"
  echo "username: admin, password: adminadmin"
fi
