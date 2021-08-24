#!/data/data/com.termux/files/usr/bin/bash
folder=arch-fs
if [ -d "$folder" ]; then
	first=1
	echo "skipping downloading"
fi
tarball="arch-rootfs.tar.gz"
if [ "$first" != 1 ];then
	if [ ! -f $tarball ]; then
		echo "Download Rootfs, this may take a while base on your internet speed."
		case `dpkg --print-architecture` in
		amd64)
			archurl="x86_64" ;;
		x86_64)
			archurl="x86_64" ;;	
		*)
			echo "unknown architecture"; exit 1 ;;
		esac
		wget "https://mirrors.ocf.berkeley.edu/archlinux/iso/latest/archlinux-bootstrap-2021.08.01-x86_64.tar.gz" -O $tarball
	fi
	cur=`pwd`
	mkdir -p "$folder"
	cd "$folder"
	echo "Decompressing Rootfs, please be patient."
	proot --link2symlink tar -xf ${cur}/${tarball}||:
	cd "$cur"
fi
mkdir -p arch-binds
mkdir -p arch-fs/tmp
bin=/data/data/com.termux/files/usr/bin/start
echo "writing launch script"
cat > $bin <<- EOM
#!/bin/bash
cd \$(dirname \$0)
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r /data/data/com.termux/files/home/$folder"
if [ -n "\$(ls -A /data/data/com.termux/files/home/arch-binds)" ]; then
    for f in /data/data/com.termux/files/home/arch-binds/* ;do
      . \$f
    done
fi
command+=" -b /dev"
command+=" -b /proc"
command+=" -b /data/data/com.termux/files/home/arch-fs/root:/dev/shm"
## uncomment the following line to have access to the home directory of termux
#command+=" -b /data/data/com.termux/files/home:/root"
## uncomment the following line to mount /sdcard directly to / 
#command+=" -b /sdcard"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM

echo "fixing shebang of launch script"
termux-fix-shebang $bin
echo "making binary executable"
chmod +x $bin
echo "removing image for some space"
rm $tarball
echo 'You can now launch Arch Linux with the "start" command'
echo "Preparing additional component for the first time, please wait..."
wget "https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/Installer/Arch/amd64/resolv.conf" -P arch-fs/root
wget "https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/Installer/Arch/amd64/additional.sh" -P arch-fs/root
echo "done"
