#!/bin/bash -x
# set -e
clear

IP_ADDRESS=$(ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

echo "This script will download and install:"
echo "Plex (via it's official repository) with Trakt"
echo "Rclone"
echo "qBittorrent"
echo "Pi-Hole"

clear
echo "Downloading and installing available updates..."
sudo apt-get update > /dev/null
sudo apt-get upgrade -y > /dev/null
echo "All updates installed successfully"

echo "Install Plex? (y/N)"
read input
if [ $reply = "y" ]
then
  wget https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/plex.sh -O plex.sh | sudo bash
else
  echo "Skipping Plex installation"
fi

echo "Install Plex-trakt-scrobbler? (y/N)?"
read input
if [ $input = "y" ]
then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/scripts/trakt.sh | sudo bash
else
  echo "Skipping Plex-Trakt-Scrobbler installation"
fi

clear
echo "Install Rclone? (y/N)?"
read input
if [ $input = "y" ]
then
  clear
  echo "Now downloading Rclone"

  #Installing fuse to mount the virtual filesystems
  sudo apt install fuse -y > /dev/null
  echo "user_allow_other" >> /etc/fuse.conf

  # Rclone install script for Debian based systems
  curl https://rclone.org/install.sh | sudo bash
  clear
  echo "Enable media.service and media_refresh.service? (y/N)"
  read input
  if [ $input = "y" ]
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
    echo "After this script finishes, set up rclone using rclone config"
    echo "Do not reboot until rclone is configured"
  else
    echo "Not enabling media.service"
    echo "Rclone was installed."
  fi
else
  echo "Not installing Rclone."
fi
sleep 3
echo "Install qBittorrent? (y/N)"
read input
if [ $input = "y" ]
then
  curl https://raw.githubusercontent.com/agneevX/easyinstall/master/ei_files/ei_qbittorrent.sh | sudo bash
else
  echo "Not installing qBittorrent"
fi

sudo systemctl daemon-reload
clear
echo "Install Pi-Hole? (y/N)"
read input
if [ $input = "y" ]
then
  clear
  echo "Now installing Pi-hole"
  # Pi-hole install script
  curl -sSL https://install.pi-hole.net | bash
else
  echo "Not installing Pi-hole"
fi

echo "Reboot system? (y/N)"
if [ $input = "y" ]
read input
then
  echo "System rebooting in 3"
  sleep 3
  sudo reboot
else
  echo "Not rebooting"
fi
echo "Exiting script..."
