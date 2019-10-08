#!/bin/bash

IP_ADDRESS=$(ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

Now "Now downloading Plex"
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
sudo apt update
sudo apt install plexmediaserver -y
clear
printf "Plex downloaded.\n"
read -p -r -n1 "Set up Plex using SSH Tunnel? (y/N)" input
if [[ $input == "Y" || $input == "y" ]]; then
  echo "AllowTCPForwarding yes" >> /etc/ssh/sshd_config
  echo "PermitOpen any" >> /etc/ssh/sshd_config
  sudo service ssh restart
  clear
  printf "Open a terminal and copy-paste this:\n"
  echo "ssh -L 32400:localhost:32400 $USER@$IP_ADDRESS"
  printf "Then open up a new browser window and paste this:\n"
  printf "http://$IP_ADDRESS:32400/web\n"
  read -p -r -n1 "Done? (y/N)" input
  if [[ $input == "Y" || $input == "y" ]]; then
    sed -i 's/AllowTCPForwarding yes/#/g' /etc/ssh/sshd_config
    sed -i 's/PermitOpen any/#/g' /etc/ssh/sshd_config
  fi
fi
echo "Plex installed"
sleep 3
