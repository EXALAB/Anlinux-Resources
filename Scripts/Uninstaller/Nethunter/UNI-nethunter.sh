#!/data/data/com.termux/files/usr/bin/bash

echo "Starting to uninstall, please be patient..."

chmod 777 -R kali-fs
rm -rf nethunter-fs
rm -rf nethunter-binds
rm -rf nethunter.sh
rm -rf start-nethunter.sh
rm -rf ssh-apt.sh
rm -rf de-apt.sh
rm -rf de-apt-xfce4.sh
rm -rf de-apt-mate.sh
rm -rf de-apt-lxqt.sh
rm -rf de-apt-lxde.sh
rm -rf UNI-nethunter.sh

echo "Done"
