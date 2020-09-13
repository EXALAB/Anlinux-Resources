#!/usr/bin/env bash

#Bootstrap the system
rm -rf $2
mkdir $2
if [ "$1" = "i386" ] || [ "$1" = "amd64" ] ; then
  debootstrap --arch=$1 --variant=minbase --include=systemd,libsystemd0,wget,ca-certificates,busybox-static rolling $1 http://mirrors.ocf.berkeley.edu/parrot
else
  qemu-debootstrap --arch=$1 --variant=minbase --include=systemd,libsystemd0,wget,ca-certificates,busybox-static rolling $1 http://mirrors.ocf.berkeley.edu/parrot
fi

#Reduce size
DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
 LC_ALL=C LANGUAGE=C LANG=C chroot $2 apt-get clean

#Fix permission on dev machine only for easy packing
chmod 777 -R $2 

#Setup DNS
echo "127.0.0.1 localhost" > $2/etc/hosts
echo "nameserver 8.8.8.8" > $2/etc/resolv.conf
echo "nameserver 8.8.4.4" >> $2/etc/resolv.conf

#sources.list setup
rm $2/etc/apt/sources.list
rm $2/etc/hostname
echo "AnLinux-Parrot" > /etc/hostname
echo "deb http://mirrors.ocf.berkeley.edu/parrot rolling main contrib non-free" >> $2/etc/apt/sources.list
echo "deb-src http://mirrors.ocf.berkeley.edu/parrot rolling main contrib non-free" >> $2/etc/apt/sources.list

#setup custom packages
chroot $2 apt-get update
chroot $2 apt-get install gvfs-daemons udisks2 -y
chroot $2 rm /var/lib/dpkg/info/udisks2.postinst
chroot $2 dpkg --configure udisks2
chroot $2 apt-get install -f
chroot $2 apt-get clean
chroot $2 apt-get autoremove -y
rm -rf $2/var/lib/apt/lists/*

#tar the rootfs
cd $2
rm -rf ../parrot-rootfs-$1.tar.xz
rm -rf dev/*
XZ_OPT=-9 tar -cJvf ../parrot-rootfs-$1.tar.xz ./*
