#!/bin/bash -x
# set -e
clear

IP_ADDRESS=$(ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

printf "This script will download and install:"
printf "Plex (via it's official repository) with Trakt"
printf "Rclone"
printf "qBittorrent"
printf "Pi-Hole"

clear
printf "Downloading and installing available updates..."
sudo apt-get update > /dev/null
sudo apt-get upgrade -y > /dev/null
printf "All updates installed successfully"

echo "Install Plex? (y/N)"
read reply
if [[ $reply = "y" ]
then
  echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
  sleep 1
  curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
  sudo apt-get update > /dev/null
  clear
  printf "Now downloading Plex"
  sudo apt-get install plexmediaserver -y > /dev/null
  clear
  printf "Plex installed successfully"
  echo "Set up Plex using SSH Tunnel? (y/N)"
  read query
  if [ $query = "y" ]
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
    read status
    if [ $status = "y" ]
    then
      sed -i 's/AllowTCPForwarding yes/#/g' /etc/ssh/sshd_config
      sed -i 's/PermitOpen any/#/g' /etc/ssh/sshd_config
    fi
  fi
else
  printf "Skipping Plex installation"
fi

echo "Install Plex-trakt-scrobbler? (y/N)?"
read query
if [ $query = "y" ]
then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/trakt.sh | sudo bash
else
  printf "Skipping Plex-Trakt-Scrobbler installation"
fi

clear
echo "Install Rclone? (y/N)?"
read query
if [ $query = "y" ]
then
  clear
  printf "Now downloading Rclone"

  #Installing fuse to mount the virtual filesystems
  sudo apt install fuse -y > /dev/null
  echo "user_allow_other" >> /etc/fuse.conf

  # Rclone install script for Debian based systems
  curl https://rclone.org/install.sh | sudo bash
  clear
  echo "Enable media.service and media_refresh.service? (y/N)"
  read query
  if [ $query = "y" ]
  then
    # Creating folders for the mounting of media.service
    sudo mkdir /mnt/media
    sudo chmod 777 /mnt/media

    cd /tmp
    wget https://raw.githubusercontent.com/agneevX/easyinstall/master/rclone/media.service -O media.service
    wget https://raw.githubusercontent.com/agneevX/easyinstall/master/rclone/media_refresh.service -O media_refresh.service
    clear

    LOCATION=$(rclone config file)

    printf "Replace the config line with:\n"
    printf "$LOCATION\n"
    echo "Ready to proceed? (y/N)"
    read answer
    if [ $answer = "y" ]
    then
      sudo nano media.refresh
    else
      exit 0
    fi
    sed -i "s/rcloneuser/$USER/g" media.service
    sed -i "s/rcloneuser/$USER/g" media_refresh.service
    # Copying systemd mounting scripts
    sudo cp media.service /etc/systemd/system/
    sudo cp media_refresh.service /etc/systemd/system/

    # Creating log file for media.service
    echo "" >> /opt/media.log
    sudo chmod 777 /opt/media.log

    sudo systemctl enable media.service > /dev/null
    sudo systemctl enable media_refresh.service > /dev/null
    printf "After this script finishes, set up rclone using rclone config"
    printf "Do not reboot until rclone is configured"
  else
    printf "Not enabling media.service"
    printf "Rclone was installed."
  fi
else
  echo "Not installing Rclone."
fi
sleep 3
echo "Install qBittorrent? (y/N)"
read query
if [ $query = "y" ]
then
  clear
  printf "Now downloading qBittorrent..."
  sleep 2
  sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
  sudo apt-get update > /dev/null
  sudo apt-get install qbittorrent-nox -y > /dev/null
  clear
  echo "Install qbittorrent.service? (y/N)?"
  read query
  if [ $query = "y" ]
  then
    cd /tmp
    wget https://raw.githubusercontent.com/agneevX/easyinstall/master/qbittorrent.service -O qbittorrent.service
    sed -i "s/qbtuser/$USER/g" /tmp/qbittorrent.service
    sudo cp /tmp/qbittorrent.service /etc/systemd/system
    sudo systemctl enable qbittorrent.service
    sudo systemctl start qbittorrent.service
    exit 0
  else
    exit 1
  fi
  if [ $? -eq 0 ]
  then
    printf "qBittorrent installed and running at port 8080"
    printf "username: admin, password: adminadmin"
  elif [ $? -eq 1 ]
  then
    printf "qBittorrent installed"
    printf "username: admin, password: adminadmin"
   fi
else
  printf "Not installing qBittorrent"
fi

sudo systemctl daemon-reload
clear
echo "Install Pi-Hole? (y/N)"
read query
if [ $query = "y" ]
then
  clear
  printf "Now installing Pi-hole"
  # Pi-hole install script
  curl -sSL https://install.pi-hole.net | bash
else
  printf "Not installing Pi-hole"
fi

echo "Reboot system? (y/N)"
read query
if [ $query = "y" ]
then
  printf "System rebooting in 3"
  sleep 3
  sudo reboot
else
  printf "Not rebooting"
fi
printf "Exiting script..."
