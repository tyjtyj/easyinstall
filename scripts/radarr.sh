cd /opt
sudo curl -L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )
sudo tar -xvzf Radarr.develop.*.linux.tar.gz
sudo rm Radarr.develop.*.linux.tar.gz
sudo chmod -R u=rw,g=r,o=r Radarr

cd /etc/systemd/system
wget --quiet -O
sed -i "s/radarr_user/$USER/g" radarr.service
