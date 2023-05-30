#!/usr/bin/bash

sudo dnf update -y rpmfusion-nonfree-release rpmfusion-free-release fedora-repos nobara-repos --refresh
sudo -S dnf distro-sync -y --refresh
sudo -S dnf update --refresh
touch /tmp/dnf.sync.success 
chown $LOGNAME:$LOGNAME /tmp/dnf.sync.success
if [ -e /etc/nobara/newinstall ]; then
	rm -Rf /etc/nobara/newinstall
fi
