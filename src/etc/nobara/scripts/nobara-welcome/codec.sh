#! /bin/bash
/usr/bin/nobara-multimedia-wizard
if [ $? -eq 0 ]; then
    zenity --error --text='Multimedia codecs already installed, no action required.'
fi
