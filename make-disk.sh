#!/bin/bash
# This script creates a new partition for AWS i3 instance nvme drive during vm first boot
# After partition is created, an XFS file system is created and the partition is then mounted on /data folder
#
# Script installation: 
#   - Place the script under /usr/bin/local
#   - sudo chmod 744 /usr/local/bin/make-disk.sh
#    - Place make-disk.service under /etc/systemd/system/make-disk.service
#   - sudo chmod 664 /etc/systemd/system/make-disk.service
#   - sudo systemctl daemon-reload
#   - sudo systemctl enable make-disk.service
#
# TODO: Change hardcoded values to allow multiple devices and filesystem types

FILE_SYSTEM_DATA=`file -s /dev/nvme0n1p1`

if [[ "$FILE_SYSTEM_DATA" != *"XFS filesystem"* ]]
then
echo "Creating new partition"
cat <<EOF | fdisk /dev/nvme0n1
n
p
1


w
EOF
echo "Sleeping for 3 seconds..."
sleep 3
echo "Creating XFS file system"
mkfs.xfs /dev/nvme0n1p1
echo "Mounting new partition on /data"
echo "/dev/nvme0n1p1  /data xfs  defaults  0  0" >> /etc/fstab
mount -a
fi
