#!/bin/bash
set -e

IP_ADDRESS=$(ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')
clear
echo "Now downloading Plex"
sleep 3
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
sudo apt update
sudo apt -y Dpkg::Options::="--force-confdef" install plexmediaserver
clear
printf "Plex downloaded.\n"
sed -i 's/#AllowTCPForwarding yes/AllowTCPForwarding yes/g' /etc/ssh/sshd_config
sed -i 's/#PermitOpen any/PermitOpen any/g' /etc/ssh/sshd_config
sudo service ssh restart
clear
printf "Open a terminal and copy-paste this:\n\n"
printf "ssh -L 32400:localhost:32400 $USER@$IP_ADDRESS\n"
printf "Then open up a new browser window and paste this:\n"
printf "http://$IP_ADDRESS:32400/web\n\n"
printf "After that is done, append '#' to:\nAllowTCPForwarding yes\nPermitOpen any\n"
printf "using sudo nano /etc/ssh/sshd_config\n"
printf "Then type sudo service ssh restart\n\n"
echo "Plex was installed"
sleep 3
exit 0
