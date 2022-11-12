#!/bin/bash

#Get the necessary components
apt-get update
apt-get install xorg kde-plasma-desktop tigervnc-standalone-server dbus-x11 -y

echo "Proccesing command provided by @maalos, this fixed error in Ubuntu 20 Focal."

rm /var/lib/dpkg/info/fprintd.postinst
rm /var/lib/dpkg/info/libfprint*.postinst
rm /var/lib/dpkg/info/libpam-fprintd*.postinst
dpkg --configure -a

echo "Done."

apt-get clean

#Setup the necessary files
mkdir ~/.vnc
wget https://raw.githubusercontent.com/EXALAB/Anlinux-Resources/master/Scripts/DesktopEnvironment/Heavy/KDE/Apt/xstartup --no-check-certificate -P ~/.vnc/
wget https://raw.githubusercontent.com/EXALAB/Anlinux-Resources/master/Scripts/DesktopEnvironment/Heavy/KDE/Apt/vncserver-start --no-check-certificate -P /usr/local/bin/
wget https://raw.githubusercontent.com/EXALAB/Anlinux-Resources/master/Scripts/DesktopEnvironment/Heavy/KDE/Apt/vncserver-stop --no-check-certificate -P /usr/local/bin/

chmod +x ~/.vnc/xstartup
chmod +x /usr/local/bin/vncserver-start
chmod +x /usr/local/bin/vncserver-stop

echo " "
echo "You can now start vncserver by running vncserver-start"
echo " "
echo "It will ask you to enter a password when first time starting it."
echo " "
echo "The VNC Server will be started at 127.0.0.1:5901"
echo " "
echo "You can connect to this address with a VNC Viewer you prefer"
echo " "
echo "Connect to this address will open a window with KDE Desktop Environment"
echo " "
echo " "
echo " "
echo "Running vncserver-start"
echo " "
echo " "
echo " "
echo "To Kill VNC Server just run vncserver-stop"
echo " "
echo " "
echo " "

echo "export DISPLAY=":1"" >> /etc/profile
source /etc/profile

vncserver-start