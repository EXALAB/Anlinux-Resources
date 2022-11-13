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

6. After image downloaded, go to the leap or tumbleweed folder and find a file named "layer.tar", and extract the file using this command (Extract command should be runned with superuser permission, otherwise you will get permission problem):

> mkdir -p layer && sudo tar -xvf layer.tar -C layer

7. At last, open a terminal in the "layer" folder, and run this command to pack the system into xz (change the file name base on your need. ALso remember to delete the layer.tar, json, VERSION file before proceeding!):

> sudo XZ_OPT=-9 tar -cJvf ../openSUSE-Leap-rootfs-armhf.tar.xz *

8. After finish processing the image, simply run this command to modify the permission:

> sudo chown -R usernamehere *
