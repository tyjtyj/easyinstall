#!/bin/bash
printf "easyinstall: rTorrent+Flood\nInstalling now"
printf "For more info visit\nhttps://no.help/rTorrent-ruTorrent-Seedbox-Guide.php#Install-Dependencies\n"
sudo

# Install rTorrent using binary archive
# Latest source, not stable as they're not always
# compatible
sudo apt install -y build-essential subversion \
autoconf screen g++ gcc ntp curl comerr-dev pkg-config cfv libtool libssl-dev libncurses5-dev \
ncurses-term libsigc++-2.0-dev libcppunit-dev libcurl4 libcurl4-openssl-dev git
svn co -q https://svn.code.sf.net/p/xmlrpc-c/code/stable /tmp/xmlrpc-c
cd /tmp/xmlrpc-c
./configure --disable-libwww-client --disable-wininet-client --disable-abyss-server --disable-cgi-server
make
sudo make install

cd /tmp
curl http://rtorrent.net/downloads/libtorrent-0.13.6.tar.gz | tar xz
cd libtorrent-0.13.6
sudo apt install zlib1g-dev -y
./autogen.sh
./configure
make
sudo make install

cd /tmp
curl http://rtorrent.net/downloads/rtorrent-0.9.6.tar.gz | tar xz
cd rtorrent-0.9.6
./autogen.sh
./configure --with-xmlrpc-c
make
sudo make install
sudo ldconfig

# Install rTorrent with rtisnt
# Including LibTorrent, ruTorrent
# and
##sudo bash -c "$(wget --no-check-certificate -qO - https://raw.githubusercontent.com/arakasi72/rtinst/master/rtsetup)"
##sudo rtinst -t #Not changing SSH port

# FLOOD INSTALLATION
## Installing Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash
nvm install --lts
sudo apt-get install -y curl git make
npm install -g node-gyp

## Installing Flood from repo
cd
sudo git clone https://github.com/Flood-UI/flood.git
sudo chown -R $USER:$USER flood
sudo chmod 777 flood
sudo cp flood/config.template.js flood/config.js
sed sed -i 's/127.0.0.1/0.0.0.0/g' flood/config.js
npm install
npm update node-sass
npm run build

## Startup script for Flood
sudo ln -s /home/$USER/.nvm/versions/node/v10.16.3/bin/node /usr/bin/node
sudo ln -s /home/$USER/.nvm/versions/node/v10.16.3/bin/npm /usr/bin/npm
cd /etc/systemd/system
wget --quiet https://raw.githubusercontent.com/agneevX/easyinstall/master/unit_files/rtorrent.service -O rtorrent.service
wget --quiet https://raw.githubusercontent.com/agneevX/easyinstall/master/unit_files/flood.service -O flood.service
sudo sed -i "s/rtorrent_user/$USER/g" rtorrent.service
sudo systemctl enable rtorrent.service
sudo systemctl enable flood.service
sudo systemctl start rtorrent
sudo systemctl start flood
