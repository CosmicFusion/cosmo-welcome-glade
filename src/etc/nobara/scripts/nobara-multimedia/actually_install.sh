#! /usr/bin/bash
        echo "10"; sleep 1
        echo "# Updating repository information"
	# refresh repo metadata
	pkcon refresh force &>/tmp/codeccheck.log
	# update repos so that we can see any new repo package changes
	pkcon update -y rpmfusion-nonfree-release fedora-repos nobara-repos 
	# refresh repo data again.
	pkcon refresh force 
        echo "20"; sleep 1
	echo "# Installing 64 bit codec packages"
	pkcon install -y faad2-libs gpac-libs gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-plugin-libav libavdevice libdca libde265 libfreeaptx libheif  
	pkcon install -y libftl librtmp live555 mjpegtools-libs mlt mlt-freeworld opencore-amr pipewire-codec-aptx svt-hevc-libs vo-amrwbenc libmediainfo mediainfo 
	pkcon install -y x264 x264-libs x265 x265-libs xvidcore vlc  
        echo "40"; sleep 1
	echo "# Installing 32 bit codec packages"
	pkcon install -y faad2-libs gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-plugin-libav libdca libde265 librtmp mjpegtools-libs --filter ~arch  
	pkcon install -y opencore-amr vo-amrwbenc x264-libs x265-libs --filter ~arch 
        echo "60"; sleep 1
	echo "# Installing hardware video encoding and decoding drivers"
	pkcon install -y intel-media-driver libva-intel-driver nvidia-vaapi-driver mesa-va-drivers-freeworld mesa-vdpau-drivers-freeworld 
        echo "80"; sleep 1
	echo "# Installing ffmpeg"
	pkcon install -y ffmpeg 
	pkcon install -y ffmpeg-libs compat-ffmpeg4 
	pkcon install -y ffmpeg-libs --filter ~arch 
	if [[ "$DESKTOP_SESSION" != "gnome" ]]; then
		pkcon install -y ffmpegthumbs 
	fi
	echo "90"; sleep 1
        if [[ "$DESKTOP_SESSION" == "gnome" ]]; then
        	echo "# Installing GSConnect (requires ffmpeg)"
                pkcon install -y gnome-shell-extension-gsconnect nautilus-gsconnect webextension-gsconnect 
        fi
        echo "100"; sleep 1
        
        # Install complete
	zenity --notification --text="Video Playback and Encoding enablement complete!" 
	echo 1 > /home/$USER/.config/nvcheck-declined
	exit 0
	/etc/nobara/scripts/nobara-multimedia/end.sh

