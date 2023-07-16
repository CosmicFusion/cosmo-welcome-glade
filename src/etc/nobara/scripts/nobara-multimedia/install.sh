#! /usr/bin/bash

BASE="faad2-libs gpac-libs gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-plugin-libav libavdevice libdca libde265 libfreeaptx libheif libftl librtmp live555 mjpegtools-libs mlt mlt-freeworld opencore-amr pipewire-codec-aptx svt-hevc-libs vo-amrwbenc libmediainfo mediainfo x264 x264-libs x265 x265-libs xvidcore vlc intel-media-driver libva-intel-driver nvidia-vaapi-driver mesa-va-drivers-freeworld mesa-vdpau-drivers-freeworld ffmpeg ffmpeg-libs compat-ffmpeg4"
MULTILIB="faad2-libs.i686 gstreamer1-plugins-bad-freeworld.i686 gstreamer1-plugins-ugly.i686 gstreamer1-plugin-libav.i686 libdca.i686 libde265.i686 librtmp.i686 mjpegtools-libs.i686 ffmpeg-libs.i686 opencore-amr.i686 vo-amrwbenc.i686 x264-libs.i686 x265-libs.i686"
REMOVEFREE="libavcodec-free libavdevice-free libavfilter-free libavutil-free libavformat-free libpostproc-free libswscale-free libswresample-free"
GNOME="gnome-shell-extension-gsconnect nautilus-gsconnect webextension-gsconnect"
KDE="ffmpegthumbs"

        PACKAGELIST="$BASE $MULTILIB"
	if [[ "$DESKTOP_SESSION" == "gnome" ]]; then
		PACKAGELIST="$PACKAGELIST $GNOME"
	fi
        if [[ "$DESKTOP_SESSION" != "gnome" ]]; then
                PACKAGELIST="$PACKAGELIST $KDE"
        fi
        # This looks weird, but basically what we do is first install any "-free" fedora-shipped versions of ffmpeg library packages, 
        # on older/existing installs, this way when we perform rpm -e later it doesn't error out. Once the '-free' versions are installed
	# We then remove them all without dependency removal and replace them with the rpmfusion ffmpeg versions alongside all of our other
	# rpmfusion codec packages.
	# The reason we install $REMOVEFREE first is because older installations may not have all of the '-free' packages, while newer
	# installations do. If any package is missing then the rpm -e command will error out.
	pkexec sh -c "dnf update -y mesa* && dnf install -y $REMOVEFREE && rpm -e --nodeps $REMOVEFREE && dnf install -y $PACKAGELIST"
        zenity --info  --title="Complete" --text="Codec installation complete!"
	if [ $? = 0 ]; then
	    /etc/nobara/scripts/nobara-multimedia/end.sh
	fi

