#!/bin/bash
printf "easyinstall: rTorrent+Flood\nInstalling now"
sudo

# Install rTorrent using binary archive
# Latest source, not stable as they're not always
# compatible
cd /tmp
wget --quiet http://rtorrent.net/downloads/rtorrent-0.9.8.tar.gz
tar -xvf rtorrent-0.9.8
cd rtorrent-0.9.8
./configure --with-xmlrpc-c
make; sudo make install
wget --quiet http://rtorrent.net/downloads/libtorrent-0.13.8.tar.gz
tar -xvf libtorrent-0.13.8
cd libtorrent-0.13.8
./configure; make; sudo make install

# Install rTorrent with rtisnt
# Including LibTorrent, ruTorrent
# and
##sudo bash -c "$(wget --no-check-certificate -qO - https://raw.githubusercontent.com/arakasi72/rtinst/master/rtsetup)"
##sudo rtinst -t #Not changing SSH port

# FLOOD INSTALLATION
## Installing Node.js
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs curl git make
npm install -g node-gyp

## Installing Flood from repo
cd /opt
sudo git clone https://github.com/Flood-UI/flood.git
sudo chown -R $USER:$USER flood
sudo cp /opt/flood/config.template.js /opt/flood/config.js
sed sed -i 's/127.0.0.1/0.0.0.0/g' /opt/flood/config.js
cd /opt/flood
npm install
sudo npm build

## Startup script for Flood
cd /etc/systemd/system
wget --quiet https://raw.githubusercontent.com/agneevX/easyinstall/master/rtorrent/rtorrent_flood.service -O flood.service
sudo systemctl enable flood.service
sudo systemctl start flood
