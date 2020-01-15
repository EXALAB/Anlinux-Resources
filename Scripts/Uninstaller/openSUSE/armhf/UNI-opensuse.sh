#!/data/data/com.termux/files/usr/bin/bash

echo "Starting to uninstall, please be patient..."

chmod 777 -R opensuse-fs
rm -rf opensuse-fs
rm -rf opensuse-binds
rm -rf opensuse.sh
rm -rf start-opensuse.sh
rm -rf UNI-opensuse.sh

echo "Done"
