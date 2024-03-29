#!/bin/bash

clear
echo "Now downloading Rclone"

#Installing fuse to mount the virtual filesystems
sudo apt install fuse -y
sudo rm /etc/fuse.conf
echo "
# /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)

# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#mount_max = 1000

# Allow non-root users to specify the allow_other or allow_root mount options.
user_allow_other" >> /etc/fuse.conf
sudo chmod u=rw,g=r,o=r /etc/fuse.conf

# Rclone install script for Debian based systems
curl https://rclone.org/install.sh | sudo bash
clear
read -p -r -n1 "Enable media.service and media_refresh.service? (y/N)" input
if [[ $input == "Y" || $input == "y" ]]; then
  # Creating folders for the mounting of media.service
  sudo mkdir /mnt/media
  sudo chmod 777 /mnt/media

  cd /tmp
  wget --quiet https://raw.githubusercontent.com/agneevX/easyinstall/master/unit_files/media.service -O media.service
  wget --quiet https://raw.githubusercontent.com/agneevX/easyinstall/master/unit_files/media_refresh.service -O media_refresh.service

  sudo cp /tmp/media.service /etc/systemd/system
  sudo cp /tmp/media_refresh.service /etc/systemd/system

  LOCATION=$(rclone config file)
  clear
  printf "Replace the config line with:\n"
  printf "$LOCATION\n"
  read -p -r -n1 "Ready to proceed? (y/N)" input
  if [[ $input == "Y" || $input == "y" ]]; then
    sudo nano media.refresh
  else
    exit 1
  fi
  sed -i "s/rcloneuser/$USER/g" media.service
  sed -i "s/rcloneuser/$USER/g" media_refresh.service

  # Creating log file for media.service
  echo "" >> /opt/media.log
  sudo chmod 777 /opt/media.log

  sudo systemctl enable media.service
  sudo systemctl enable media_refresh.service
  echo "After this script finishes, set up rclone using rclone config"
  echo "Do not reboot until rclone is configured"
else
  echo "Not enabling media.service"
  echo "Rclone was installed."
fi
exit 0
