#!/bin/bash

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
