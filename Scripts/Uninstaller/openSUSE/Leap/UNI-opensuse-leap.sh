#!/data/data/com.termux/files/usr/bin/bash

echo "Starting to uninstall, please be patient..."

chmod 777 -R opensuse-leap-fs
rm -rf opensuse-leap-fs
rm -rf opensuse-leap-binds
rm -rf opensuse-leap.sh
rm -rf /data/data/com.termux/files/usr/bin/start
rm -rf UNI-opesuse-leap.sh

echo "Done"
