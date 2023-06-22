#!/bin/sh

# write a custom script to fix resolve crashing on libpango due to glib2 update
cat > /usr/bin/resolve << EOF
#!/bin/sh
LD_PRELOAD=/usr/lib64/libglib-2.0.so /opt/resolve/bin/resolve "$@"
EOF

# make it executable
chmod +x /usr/bin/resolve

# fix our global shortcut so it runs our custom resolve script
if [ -f /usr/share/applications/com.blackmagicdesign.resolve.desktop ];then
        if [[ -z $(cat /usr/share/applications/com.blackmagicdesign.resolve.desktop | grep "bash -c") ]]; then
        	sed -i 's|Exec=/opt/resolve/bin/resolve %u|Exec=/usr/bin/resolve %u|g' /usr/share/applications/com.blackmagicdesign.resolve.desktop
	fi
fi

# install rocm packages for opencl support
dnf install -y rocm-opencl

