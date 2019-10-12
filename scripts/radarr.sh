#!/bin/bash

# Installing mono
sudo apt install gnupg ca-certificates
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt update
sudo apt install -y mono-devel

cd /opt
sudo curl -L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )
sudo tar -xvzf Radarr.develop.*.linux.tar.gz
sudo rm Radarr.develop.*.linux.tar.gz
sudo chmod -R u=rw,g=r,o=r Radarr

cd /etc/systemd/system
wget --quiet https://raw.githubusercontent.com/agneevX/easyinstall/master/unit_files/radarr.service -O radarr.service
sed -i "s/radarr_user/$USER/g" radarr.service

sudo systemctl enable radarr
sudo systemctl start radarr
