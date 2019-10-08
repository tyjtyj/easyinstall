#!/bin/bash

clear
Now "Now downloading Plex"
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
sleep 1
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
sudo apt update > /dev/null
clear
echo "Now downloading Plex"
sudo apt install plexmediaserver -y > /dev/null
clear
printf "Plex downloaded.\n"
echo "Set up Plex using SSH Tunnel? (y/N)"
read input
if [ $input = "y" ]
then
  clear
  echo "AllowTCPForwarding yes" >> /etc/ssh/sshd_config
  echo "PermitOpen any" >> /etc/ssh/sshd_config
  sudo service ssh restart
  clear
  printf "Open a terminal and copy-paste this:\n"
  echo "ssh -L 32400:localhost:32400 $USER@$IP_ADDRESS"
  printf "Then open up a new browser window and paste this:\n"
  printf "http://localhost:32400/web\n"
  echo "Done? (y/N)"
  read input
  if [ $input = "y" ]
  then
    sed -i 's/AllowTCPForwarding yes/#/g' /etc/ssh/sshd_config
    sed -i 's/PermitOpen any/#/g' /etc/ssh/sshd_config
  fi
fi
echo "Plex installed"
sleep 3
