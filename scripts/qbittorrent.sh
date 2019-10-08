#!/bin/bash

IP_ADDRESS=$(ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

echo "Now downloading qBittorrent..."
sleep 2
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
sudo apt-get update > /dev/null
sudo apt-get install qbittorrent-nox -y > /dev/null
echo "Installed"
read -p -r -n1 "Install qbittorrent.service? (y/N)?" input
if [[ $input == "Y" || $input == "y" ]]; then
  cd /etc/systemd/system
  wget https://raw.githubusercontent.com/agneevX/easyinstall/master/qbittorrent.service -O qbittorrent.service
  sed -i "s/qbtuser/$USER/g" /etc/systemd/system/qbittorrent.service
  sudo systemctl enable qbittorrent.service
  sudo systemctl start qbittorrent.service
  exit 0
else
  exit 1
fi
if [ $? -eq 0 ]
  echo "qBittorrent installed and running at port "$IP_ADDRESS":8080"
elif [ $? -eq 1 ]
  echo "qBittorrent installed"
fi
echo "username: admin, password: adminadmin"
