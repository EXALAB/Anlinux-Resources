#!/data/data/com.termux/files/usr/bin/bash

echo "Starting to uninstall, please be patient..."

chmod 777 -R void-fs
rm -rf void-fs
rm -rf void-binds
rm -rf void.sh
rm -rf /data/data/com.termux/files/usr/bin/start
rm -rf UNI-void.sh

echo "Done"
