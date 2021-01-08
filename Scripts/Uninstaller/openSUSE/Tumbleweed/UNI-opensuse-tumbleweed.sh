#!/data/data/com.termux/files/usr/bin/bash

echo "Starting to uninstall, please be patient..."

chmod 777 -R opensuse-tumbleweed-fs
rm -rf opensuse-tumbleweed-fs
rm -rf opensuse-tumbleweed-binds
rm -rf opensuse-tumbleweed.sh
rm -rf /data/data/com.termux/files/usr/bin/start
rm -rf UNI-opesuse-tumbleweed.sh

echo "Done"
