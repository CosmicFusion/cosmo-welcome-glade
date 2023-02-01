#! /bin/bash

INTERNET="no"
DNF_STATE_STAGE=false

internet_check() {
      # Check for internet connection
      wget -q --spider http://google.com
      if [ $? -eq 0 ]; then
          export INTERNET="yes"
      fi
}

dnf_install_progress() {	
	pkexec bash -c "sudo dnf update -y rpmfusion-nonfree-release rpmfusion-free-release fedora-repos nobara-repos --refresh && sudo -S dnf distro-sync -y --refresh && sudo -S dnf update --refresh && touch /tmp/dnf.sync.success && chown $LOGNAME:$LOGNAME /tmp/dnf.sync.success" | tee /dev/tty | grep -i 'Running transaction check' && export DNF_STATE_STAGE=true
}

flatpak_install_progress() {
	if zenity --question --text="Flatpak has been detected! Would like to update all Flatpaks on your system?"
	then
	flatpak update --appstream && flatpak update && pkexec bash -c "flatpak update --appstream && flatpak update && touch /tmp/flatpak.sync.success && chown $LOGNAME:$LOGNAME /tmp/flatpak.sync.success" 
	fi
}

snap_install_progress() {
	if zenity --question --text="Snap has been detected! Would like to update all Snaps on your system?"
	then
	pkexec bash -c "snap refresh && touch /tmp/snap.sync.success && chown $LOGNAME:$LOGNAME /tmp/snap.sync.success"
	fi
}

internet_check

### DNF UPGRADE
if [[ $INTERNET == yes ]]; then
	dnf_install_progress
fi

### Flatpak UPGRADE
if [[ $INTERNET == yes ]] && [[ -x "$(command -v flatpak)" ]]; then
	if flatpak --version
	then
	flatpak_install_progress
	fi
fi

### Snap UPGRADE
if [[ $INTERNET == yes ]] && [[ -x "$(command -v snap)" ]]; then
	if snap --version
	then
	snap_install_progress
	fi
fi

### Final dialog
if cat /tmp/dnf.sync.success ; then
    if [[ $DNF_STATE_STAGE == true ]]; then
    	if zenity --question --title='Update my system' --text='Update complete! It is recommended to reboot for changes to apply properly. Reboot now?' 
    	then
    		rm /tmp/dnf.sync.success
    		systemctl reboot
    	else
    		rm /tmp/dnf.sync.success
    	fi
    else
    	zenity --info --title='Update my system' --text='No updates required, your system is already up to date!' 
    fi
else
	zenity --error --title='Update my system' --text="Failed to update!"
	rm /tmp/dnf.sync.success
fi
rm /tmp/dnf.sync.success
