#!/usr/bin/bash

sudo -S dnf update -y rpmfusion-nonfree-release rpmfusion-free-release fedora-repos nobara-repos --refresh
sudo -S dnf distro-sync -y --refresh
sudo -S dnf update -y --refresh
if [ -e /etc/nobara/newinstall ]; then
	rm -Rf /etc/nobara/newinstall
fi
