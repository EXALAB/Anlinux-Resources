How these image are made:

1. Pull the image using this command:

> sudo docker pull --platform=linux/arm64/v8 opensuse/leap:latest

There are four Architecture for AnLinux:

> linux/386
linux/amd64
linux/arm/v7
linux/arm64/v8

(i386 is not available for openSUSE Leap)

Alternatively, you can also run these command to know what to pull for:

> docker manifest inspect opensuse/leap:latest
docker manifest inspect opensuse/tumbleweed:latest

2. Then run this command to export the image:

> sudo docker save --platform=linux/arm64/v8 -o output.tar opensuse/leap:latest

3. Extract output.tar, then extract the archive inside /blobs/sha256/.

4. At last, open a terminal in the folder with the content of archive we extracted just now, and run this command to pack the system into xz (change the file name base on your need:

> sudo XZ_OPT=-9 tar -cJvf ../openSUSE-Leap-rootfs-armhf.tar.xz *

5. After finish processing the image, simply run this command to modify the permission:

> sudo chown -R usernamehere *

6. Don't forget to delete the pulled image afterwards:

> docker images -a
docker rmi <image_ID>
