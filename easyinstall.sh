#!/bin/bash
# set -e
clear

IP_ADDRESS=$(ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

echo "This script will download and install:"
sleep 1
echo "Plex (via it's official repository) with Trakt"
sleep 1
echo "Rclone"
sleep 1
echo "qBittorrent"
sleep 1
echo "Pi-Hole"
sleep 2

clear
echo "Downloading and installing available updates..."
sleep 2
sudo apt-get update > /dev/null
sudo apt-get upgrade -y > /dev/null
echo "All updates installed successfully"
sleep 2

clear
echo "Install Plex? (y/N)"
read query
if [ $query = "y" ];
then
  clear
  echo "Now downloading Plex"
  sleep 2
  echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
  sleep 1
  curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add - 
  sudo apt-get update > /dev/null
  sudo apt-get install plexmediaserver -y > /dev/null
  clear
  echo "Plex installed successfully"
  sleep 2
  echo "Set up Plex using SSH Tunnel? (y/N)"
  read query
  if [ $query = "y" ];
  then
    clear
    echo "AllowTCPForwarding yes" >> /etc/ssh/sshd_config
    echo "PermitOpen any" >> /etc/ssh/sshd_config
    sudo service ssh restart
    clear
    echo "Open a terminal and copy-paste this:"
    echo "ssh -L 32400:localhost:32400 $USER@$IP_ADDRESS"
    sleep 2
    echo "Then open up a new browser window and paste this:"
    echo ""
    echo "http://localhost:32400/web"
    echo ""
    echo "Done? (y/N)"
    if [ $query = "y" || $query = "Y" ];
    then
      sed -i 's/AllowTCPForwarding yes/# AllowTCPForwarding yes/g' /etc/ssh/sshd_config
      sed -i 's/PermitOpen any/# PermitOpen any/g' /etc/ssh/sshd_config
    else
      exit 1
    fi
else
  echo "Skipping Plex installation"
fi

echo "Install Plex-trakt-scrobbler? (y/N)?"
read query
if [ $query = "y" ];
then
  clear
  echo "Now downloading Plex Trakt Scrobbler"
  sleep 2
  wget -P /tmp https://github.com/trakt/Plex-Trakt-Scrobbler/archive/master.zip -O Plex-Trakt-Scrobbler.zip > /dev/null
  clear
  echo "Trakt downloaded"
  sudo apt-get install unzip -y > /dev/null
  clear
  echo "Unzipping downloaded archive"
  unzip /tmp/Plex-Trakt-Scrobbler.zip > /dev/null
  sudo cp -r /tmp/Plex-Trakt-Scrobbler-*/Trakttv.bundle "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-ins/"
  clear
  echo "Trakt installed"

  #Downloading apsw.so and trakt databases
  wget -P /tmp https://www.dropbox.com/s/jo9jam8n73htkqc/trakt.zip?dl=1 -O trakt.zip > /dev/null
  unzip /tmp/trakt.zip > /dev/null

  #Changing ownership and modifying permissions
  sudo chown plex:plex /tmp/trakt/com.plexapp.plugins.trakttv.db
  sudo chown plex:plex /tmp/trakt/com.plexapp.plugins.trakttv.db-shm
  sudo chown plex:plex /tmp/trakt/com.plexapp.plugins.trakttv.db-wal
  sudo chmod u=rw,g=r,o=r /tmp/trakt/com.plexapp.plugins.trakttv.db
  sudo chmod u=rw,g=r,o=r /tmp/trakt/com.plexapp.plugins.trakttv.db-shm
  sudo chmod u=rw,g=r,o=r /tmp/trakt/com.plexapp.plugins.trakttv.db-wal

  sudo cp /tmp/trakt/apsw.so /usr/lib/plexmediaserver/Resources/Python/lib/python2.7/lib-dynload
  clear
  echo "Moved apsw.so"
  sleep 2
  sudo cp /tmp/trakt/com.plexapp.plugins.trakttv.db "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
  sudo cp /tmp/trakt/com.plexapp.plugins.trakttv.db-shm "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
  sudo cp /tmp/trakt/com.plexapp.plugins.trakttv.db-wal "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
  clear
  echo "Moved databases"
else
  echo "Skipping Plex-Trakt-Scrobbler installation"
fi

sleep 2
sudo systemctl restart plexmediaserver
clear
echo "Restarted Plex"
sleep 2

clear
echo "Install Rclone? (y/N)?"
read query
if [ $query = "y" ];
then
  clear
  echo "Now downloading Rclone"
  sleep 2
  
  #Installing fuse to mount the virtual filesystems
  sudo apt install fuse -y > /dev/null
  echo "user_allow_other" >> /etc/fuse.conf
  
  # Rclone install script for Debian based systems
  curl https://rclone.org/install.sh | sudo bash
  
  clear
  echo "Enable media.service and media_refresh.service? (y/N)"
  read query
  if [ $query = "y" ];
  then
    # Creating folders for the mounting of media.service
    sudo mkdir /mnt/media
    sudo chmod 777 /mnt/media
    
    wget -P /tmp https://raw.githubusercontent.com/muskingo/easyinstall/master/rclone/media.service -O media.service > /dev/null
    wget -P /tmp https://raw.githubusercontent.com/muskingo/easyinstall/master/rclone/media_refresh.service -O media_refresh.service > /dev/null
    
    sed -i 's/root/$USER/g' media.service
    sed -i 's/root/$USER/g' media_refresh.service
    
    sudo cp media.service /etc/systemd/system/
    sudo cp media_refresh.service /etc/systemd/system/
      
    # Creating log file for media.service
    echo "" >> /opt/media.log
    sudo chmod 777 /opt/media.log
    
    sudo systemctl enable media.service > /dev/null
    sudo systemctl enable media_refresh.service > /dev/null
    echo "After this script finishes, set up rclone using rclone config"
    sleep 3
  fi
  else
    echo "Not enabling media.service"
    sleep 1
    echo "Rclone was installed."
else
  echo "Not installing Rclone."
fi

echo "Install qBittorrent? (y/N)"
read query
if [ $query = "y" ];
then
  clear
  echo "Now downloading qBittorrent..."
  sleep 2
  sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
  sleep 1
  sudo apt-get update > /dev/null
  sudo apt-get install qbittorrent-nox -y > /dev/null
  clear
  echo "Install qbittorrent.service? (y/N)?"
  read query
  if [ $query = "y" ]
  then
    wget -P /tmp https://raw.githubusercontent.com/muskingo/easyinstall/master/qbittorrent.service -O qbittorrent.service
    sed -i 's/root/$USER/g' /tmp/qbittorrent.service
    sudo cp /tmp/qbittorrent.service /etc/systemd/system
    sudo systemctl enable qbittorrent.service
    sudo systemctl start qbittorrent.service
    exit 0
  else
    exit 1
  fi
  if [ $? -eq 0 ];
  then
    echo "qBittorrent installed and running at port 8080"
    echo "username: admin, password: adminadmin"
  else if [ $? -eq 1 ];
    echo "qBittorrent installed"
    echo "username: admin, password: adminadmin"
   fi
  fi
else
  echo "Not installing qBittorrent"
fi

sudo systemctl daemon-reload

echo "Install Pi-Hole? (y/N)"
read query
if [ $query = "y" ];
then
  clear
  echo "Now installing Pi-hole"
  sleep 2
  # Pi-hole install script
  curl -sSL https://install.pi-hole.net | bash
else
  echo "Not installing Pi-hole"
fi

echo "Reboot system? (y/N)"
read query
if [ $query = "y" ];
then
  echo "System rebooting in 3"
  sleep 1
  clear
  echo "System rebooting in 2"
  sleep 1
  clear
  echo "System rebooting in 1"
  sleep 1
  sudo reboot
else
  echo "Not rebooting"
fi
sleep 1
clear
echo "Exiting script..."
