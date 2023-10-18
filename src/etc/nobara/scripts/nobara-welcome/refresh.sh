#! /bin/bash
PASSWORD=$(zenity --password) 
CORRECT_PASSWD=0
while [[ $CORRECT_PASSWD = 0 ]]
do
	if echo $PASSWORD | sudo -S echo good
	then
		export CORRECT_PASSWD=1
	else
		unset PASSWORD && export PASSWORD=$(zenity --password)
	fi
done

INTERNET="no"
DNF_STATE_STAGE=false

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
	echo $PASSWORD | sudo -S bash /etc/nobara/scripts/nobara-welcome/updater.sh | tee /dev/tty | grep -i 'Running transaction check' && export DNF_STATE_STAGE=true
	touch /tmp/dnf.sync.success
}

flatpak_install_progress() {
	if zenity --question --text="Flatpak has been detected! Would like to update all Flatpaks on your system?"
	then
	echo $PASSWORD | sudo -S bash -c "flatpak update --appstream -y && flatpak update -y && touch /tmp/flatpak.sync.success && chown $LOGNAME:$LOGNAME /tmp/flatpak.sync.success" && flatpak update --appstream -y && flatpak update -y
	fi
}

snap_install_progress() {
	if zenity --question --text="Snap has been detected! Would like to update all Snaps on your system?"
	then
	echo $PASSWORD | sudo -S bash -c "snap refresh && touch /tmp/snap.sync.success && chown $LOGNAME:$LOGNAME /tmp/snap.sync.success"
	fi
}

internet_check

### DNF UPGRADE
if [[ $INTERNET == yes ]]; then
	dnf_install_progress
fi

### Flatpak UPGRADE
if [[ $INTERNET == yes ]] && [[ -x "$(command -v flatpak)" ]]; then
	flatpak_install_progress
fi

### Snap UPGRADE
if [[ $INTERNET == yes ]] && [[ -x "$(command -v snap)" ]]; then
	snap_install_progress
fi

### Final dialog
if cat /tmp/dnf.sync.success ; then
    if [[ $DNF_STATE_STAGE == true ]]; then
    	if zenity --question --title='Update my system' --text='Update complete! It is recommended to reboot for changes to apply properly. Reboot now?' 
    	then
    		rm -Rf /tmp/dnf.sync.success
    		systemctl reboot
    	else
    		rm -Rf /tmp/dnf.sync.success
    	fi
    else
    	zenity --info --title='Update my system' --text='No updates required, your system is already up to date!' 
    fi
else
	zenity --error --title='Update my system' --text="Failed to update!"
	rm -Rf /tmp/dnf.sync.success
fi
rm /tmp/dnf.sync.success


