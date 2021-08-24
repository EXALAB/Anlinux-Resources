#!/data/data/com.termux/files/usr/bin/bash
if [ -d "$folder" ]; then
	first=1
	echo "skipping downloading"
fi
tarball="nethunter-rootfs.tar.gz"
if [ "$first" != 1 ];then
	if [ ! -f $tarball ]; then
		echo "Download Rootfs, this may take a while base on your internet speed."
		case `dpkg --print-architecture` in
		aarch64)
			archurl="arm64" ;;	
		arm)
			archurl="armhf" ;;
		amd64)
			archurl="amd64" ;;
		x86_64)
			archurl="amd64" ;;	
		i*86)
			archurl="i386" ;;
		x86)
			archurl="i386" ;;
		*)
			echo "unknown architecture"; exit 1 ;;
		esac
		wget "https://build.nethunter.com/kalifs/kalifs-latest/kalifs-${archurl}-full.tar.xz" -O $tarball
	fi
	cur=`pwd`
	echo "Decompressing Rootfs, please be patient."
	proot --link2symlink tar -xJf ${cur}/${tarball} --exclude='dev'||:
	cd "$cur"
fi
mv kali-${archurl} nethunter-fs
rm nethunter-fs/etc/apt/sources.list
rm -rf nethunter-fs/dev
echo "deb http://mirror.fsmg.org.nz/kali kali-rolling main contrib non-free" >> nethunter-fs/etc/apt/sources.list
echo "deb-src http://mirror.fsmg.org.nz/kali kali-rolling main contrib non-free" >> nethunter-fs/etc/apt/sources.list
wget https://archive.kali.org/archive-key.asc -O nethunter-fs/etc/apt/trusted.gpg.d/kali-archive-key.asc
mkdir -p nethunter-binds
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
command+=" -r /data/data/com.termux/files/home/nethunter-fs"
if [ -n "\$(ls -A /data/data/com.termux/files/home/nethunter-binds)" ]; then
    for f in /data/data/com.termux/files/home/nethunter-binds/* ;do
      . \$f
    done
fi
command+=" -b /dev"
command+=" -b /proc"
command+=" -b /data/data/com.termux/files/home/nethunter-fs/root:/dev/shm"
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
echo 'You can now launch Kali Nethunter with the "start" command'
