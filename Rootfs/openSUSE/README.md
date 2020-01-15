How these image are made:

1. Download the script here:

[Script](https://github.com/EXALAB/AnLinux-Resources/tree/master/Scripts/Docker)

2. Then install the required things:

> sudo apt-get install curl jq golang

3. Export GOARCH to something you want:

> export GOARCH=somearch

There are four Architecture for AnLinux:

> 386
amd64
arm
arm64

4. Then run the script:

For Leap:

> ./fetch-docker-image.sh leap opensuse/leap:latest

For Tumbleweed:

> ./fetch-docker-image.sh tumbleweed opensuse/tumbleweed:latest

5. After image downloaded, go to the tumbleweed folder and find a folder named "layer", and extract the layer folder.

6. At last, open a terminal in the extracted folder, and run this command to pack the system into xz (change the file name base on your need. ALso remember to delete the layer.tar, json, VERSION file before proceeding!):

> XZ_OPT=-9 tar -cJvf ../openSUSE-Leap-rootfs-armhf.tar.xz *
