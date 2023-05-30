#! /usr/bin/bash


	pkexec sh -c "dnf install -y rocm-opencl"
        zenity --info  --title="Complete" --text="Davinci Resolve package dependency installation complete!"
	if [ $? = 0 ]; then
	    /etc/nobara/scripts/nobara-davinci/end.sh
	fi
