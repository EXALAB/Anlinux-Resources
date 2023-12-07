#!/usr/bin/env bash

#Bootstrap the system
rm -rf $2
mkdir $2
if [ "$1" = "i386" ] || [ "$1" = "amd64" ] ; then
  debootstrap --arch=$1 --variant=minbase --include=systemd,libsystemd0,wget,ca-certificates,gnupg,busybox-static jammy $1 http://archive.ubuntu.com/ubuntu
else  
  qemu-debootstrap --arch=$1 --variant=minbase --include=systemd,libsystemd0,wget,ca-certificates,gnupg,busybox-static jammy $1 http://ports.ubuntu.com/ubuntu-ports
fi

#Reduce size
DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
 LC_ALL=C LANGUAGE=C LANG=C chroot $2 apt clean

#Fix permission on dev machine only for easy packing
chmod 777 -R $2

#This step is also needed for BackBox as it is based on Ubuntu Focal
touch $2/root/.hushlogin

#This step is only needed for BackBox to import BackBox repo key
chroot $2 apt-key adv --keyserver keyserver.ubuntu.com --recv-key 680E1A5A78A7ABE1

#Setup DNS
echo "127.0.0.1 localhost" > $2/etc/hosts
echo "nameserver 8.8.8.8" > $2/etc/resolv.conf
echo "nameserver 8.8.4.4" >> $2/etc/resolv.conf

#sources.list setup
rm $2/etc/apt/sources.list
rm $2/etc/hostname
echo "AnLinux-BackBox" > $2/etc/hostname
if [ "$1" = "i386" ] || [ "$1" = "amd64" ] ; then
  echo "deb http://archive.ubuntu.com/ubuntu jammy main restricted universe multiverse" >> $2/etc/apt/sources.list
  echo "deb http://archive.ubuntu.com/ubuntu jammy-backports main restricted universe multiverse" >> $2/etc/apt/sources.list
  echo "deb http://archive.ubuntu.com/ubuntu jammy-proposed main restricted universe multiverse" >> $2/etc/apt/sources.list
  echo "deb http://archive.ubuntu.com/ubuntu jammy-security main restricted universe multiverse" >> $2/etc/apt/sources.list
  echo "deb http://archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse" >> $2/etc/apt/sources.list
  echo "deb-src http://archive.ubuntu.com/ubuntu jammy main restricted universe multiverse" >> $2/etc/apt/sources.list
  echo "" >> $2/etc/apt/sources.list
  echo "deb http://ppa.launchpadcontent.net/backbox/eight/ubuntu jammy main" >> $2/etc/apt/sources.list
  echo "deb-src http://ppa.launchpadcontent.net/backbox/eight/ubuntu jammy main" >> $2/etc/apt/sources.list
else  
  echo "deb http://ports.ubuntu.com/ubuntu-ports jammy main restricted universe multiverse" >> $2/etc/apt/sources.list
  echo "deb http://ports.ubuntu.com/ubuntu-ports jammy-backports main restricted universe multiverse" >> $2/etc/apt/sources.list
  echo "deb http://ports.ubuntu.com/ubuntu-ports jammy-proposed main restricted universe multiverse" >> $2/etc/apt/sources.list
  echo "deb http://ports.ubuntu.com/ubuntu-ports jammy-security main restricted universe multiverse" >> $2/etc/apt/sources.list
  echo "deb http://ports.ubuntu.com/ubuntu-ports jammy-updates main restricted universe multiverse" >> $2/etc/apt/sources.list
  echo "deb-src http://ports.ubuntu.com/ubuntu-ports jammy main restricted universe multiverse" >> $2/etc/apt/sources.list
  echo "" >> $2/etc/apt/sources.list
  echo "deb http://ppa.launchpadcontent.net/backbox/eight/ubuntu jammy main" >> $2/etc/apt/sources.list
  echo "deb-src http://ppa.launchpadcontent.net/backbox/eight/ubuntu jammy main" >> $2/etc/apt/sources.list
fi

#setup custom packages
chroot $2 apt update
chroot $2 apt upgrade -y
chroot $2 apt dist-upgrade -y
chroot $2 apt install gvfs-daemons udisks2 -y
chroot $2 rm /var/lib/dpkg/info/udisks2.postinst
chroot $2 dpkg --configure udisks2
chroot $2 apt install -f
chroot $2 apt clean
chroot $2 apt autoremove -y
rm -rf $2/var/lib/apt/lists/*

#tar the rootfs
cd $2
rm -rf ../backbox-rootfs-$1.tar.xz
rm -rf dev/*
XZ_OPT=-9 tar -cJvf ../backbox-rootfs-$1.tar.xz ./*
