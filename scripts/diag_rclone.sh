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
# Creating folders for the mounting of media.service
sudo mkdir /mnt/media
sudo chmod 777 /mnt/media

cd /etc/systemd/system
wget --quiet https://raw.githubusercontent.com/agneevX/easyinstall/master/unit_files/media.service -O media.service
wget --quiet https://raw.githubusercontent.com/agneevX/easyinstall/master/unit_files/media_refresh.service -O media_refresh.service

sudo chmod 755 media.service
sudo chmod 755 media_refresh.service

sed -i "s/rcloneuser/$USER/g" media.service
sed -i "s/rcloneuser/$USER/g" media_refresh.service

# Creating log file for media.service
echo "" >> /opt/media.log
sudo chmod 777 /opt/media.log

sudo systemctl enable media.service
sudo systemctl enable media_refresh.service
clear
echo "After this script finishes, set the rclone.conf location"
echo "sudo nano /etc/systemd/system/media.service\n\n"
printf "/home/$USER/.config/rclone/rclone.conf"
printf "Do not reboot until rclone is configured\n\n"
echo "Rclone was installed."
exit 0
