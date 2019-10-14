#!/bin/bash

IP_ADDRESS=$(ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

echo "Now downloading qBittorrent..."
sleep 2
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
sudo apt-get update
sudo apt-get install qbittorrent-nox -y
echo "Installed"
sleep 3
cd /etc/systemd/system
wget https://raw.githubusercontent.com/agneevX/easyinstall/master/unit_files/qbittorrent.service -O qbittorrent.service
sudo sed -i "s/qbtuser/$USER/g" /etc/systemd/system/qbittorrent.service
sudo systemctl enable qbittorrent.service
sudo systemctl start qbittorrent.service
clear
echo "qBittorrent installed and running at port "$IP_ADDRESS":8080"
echo "username: admin, password: adminadmin"
