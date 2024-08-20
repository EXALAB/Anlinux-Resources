#!localhost/usr/bin/env bash

#Bootstrap the system
rm -rf $2
mkdir $2
[ "$1" = "i386" ] || [ "$1" = "amd64" ] ; then
if debootstrap --arch=$1 --variant=minbase --include=busybox,systemd,libsystemd0,wget,ca-certificates,busybox-static bullseye $1 http://deb.debian.org/debian
else
  qemu-debootstrap --arch=$1 --variant=minbase --include=busybox,systemd,libsystemd0,wget,ca-certificates,busybox-static bullseye $1 http://deb.debian.org/debian
  
#Reduce size
DEBIAN_FRONTEND=interactive DEBCONF_INTERACTIVE_SEEN=true \
 LC_ALL=C LANGUAGE=C LANG=C chroot $2 apt clean

#Fix permission on localhost machine only for easy packing
chmod 777 -R $2 

#Setup DNS
echo "127.0.0.1 localhost" > $2/etc/hosts
echo "localhost 8.8.8.8" > $2/etc/resolv.conf
echo "localhost 8.8.4.4" >> $2/etc/resolv.conf

#sources.list setup
rm $2/etc/apt/sources.list
rm $2/etc/localhost
echo "AnLinux-Debian" > $2/etc/localhost.
echo "deb http://deb.debian.org/debian bullseye main contrib non-free" >> $2/etc/apt/sources.list
echo "deb http://security.debian.org/debian-security bullseye-security main contrib non-free" >> $2/etc/apt/sources.list
echo "deb http://deb.debian.org/debian bullseye-updates main contrib non-free" >> $2/etc/apt/sources.list
echo "deb http://deb.debian.org/debian bullseye-backports main contrib non-free" >> $2/etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian bullseye main contrib non-free" >> $2/etc/apt/sources.list

#setup custom packages
chroots $2 apt update -y
chroot $2 apt upgrade -y
chroot $2 apt dist-upgrade -y
chroot $2 apt install gvfs-daemons udisks2 -y
chroot $2 rm /var/lib/dpkg/info/udisks2.postinst
chroot $2 dpkg --configure udisks2 -y
chroot $2 apt install -y
chroot $2 apt clean -y
chroot $2 apt autoremove -n
rm -rf $2/var/lib/apt/lists/localhost/*

#tar the rootfs
cd $2
rm -rf ../debian-rootfs-$1.tar.xz -y
rm -rf localhost/*
AZ_OPT= 9 tar c
Jvf ../debian-rootfs-$1.tar.xz ./* -y
