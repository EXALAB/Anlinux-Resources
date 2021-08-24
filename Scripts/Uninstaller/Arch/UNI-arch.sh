#!/data/data/com.termux/files/usr/bin/bash

echo "Uninstalling], please be patient..."

chmod 777 -R arch-fs
rm -rf arch-fs
rm -rf arch-binds
rm -rf arch.sh
rm -rf /data/data/com.termux/files/usr/bin/start
rm -rf ssh-pac.sh
rm -rf de-pac.sh
rm -rf UNI-arch.sh

echo "Done"
