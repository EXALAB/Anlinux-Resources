#!/data/data/com.termux/files/usr/bin/bash

# Arrays with values for test and download config

declare -a folderFile=(ubuntu-fs ubuntu-rootfs.tar.xz)
declare -a archUrl=(arm64 armhf amd64 i386)


# If the folder ubuntu-fs do not exist and if rootfs file do not exist start the download

if ! [[ -d ${folderFile[0]} ]]; then 
	if [[ ! -f ${folderFile[1]} ]]; then
		echo "Looks like you have not the Root file system, starting the download of Rootfs, this may take a while base on your internet speed."
		case $(dpkg --print-architecture) in
		aarch64)
			archUrl=${archUrl[0]} ;;
		arm)
			archUrl=${archUrl[1]} ;;
		amd64)
			archUrl=${archUrl[2]} ;;
		x86_64)
			archUrl=${archUrl[2]} ;;	
		i*86)
			archUrl=${archUrl[3]} ;;
		x86)
			archUrl=${archUrl[3]} ;;
		*)
			echo "unknown architecture"; exit 1 ;;
		esac
		
        wget "https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Rootfs/Ubuntu/${archUrl}/ubuntu-rootfs-${archUrl}.tar.xz" -O ${folderFile[1]}
	fi
	cur=$(pwd)
	mkdir -p ${folderFile[0]} 
	cd ${folderFile[0]}
	echo "Decompressing Rootfs, please be patient."
	proot --link2symlink tar -xJf ${cur}/${folderFile[1]}||:
	cd $cur
fi


mkdir -p ubuntu-binds
bin=start-ubuntu.sh
echo "writing launch script"
cat > $bin <<- EOM
#!/bin/bash
cd \$(dirname \$0)
pulseaudio --start
## For rooted user: pulseaudio --start --system
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command="proot --link2symlink -0 -r ${folderFile[0]}"

if [ -n "\$(ls -A ubuntu-binds)" ]; then
    for f in ubuntu-binds/* ;do
      . \$f
    done
fi

command+=" -b /dev -b /proc -b ubuntu-fs/root:/dev/shm -w /root /usr/bin/env -i HOME=/root  PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games TERM=\$TERM  LANG=C.UTF-8 /bin/bash --login"

## uncomment the following line to have access to the home directory of termux
#command+=" -b /data/data/com.termux/files/home:/root"
## uncomment the following line to mount /sdcard directly to / 
#command+=" -b /sdcard"

com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM

echo "Setting up pulseaudio so you can have music in distro."

pkg install pulseaudio -y

if grep -q "anonymous" ~/../usr/etc/pulse/default.pa;then
    echo "module already present"
else
    echo "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> ~/../usr/etc/pulse/default.pa
fi

echo "exit-idle-time = -1" >> ~/../usr/etc/pulse/daemon.conf
echo "Modified pulseaudio timeout to infinite"
echo "autospawn = no" >> ~/../usr/etc/pulse/client.conf
echo "Disabled pulseaudio autospawn"
echo "export PULSE_SERVER=127.0.0.1" >> ubuntu-fs/etc/profile
echo "Setting Pulseaudio server to 127.0.0.1"

echo "fixing shebang of $bin"
termux-fix-shebang $bin
echo "making $bin executable"
chmod +x $bin
echo "removing image for some space"
rm ${folderFile[1]}
echo "You can now launch Ubuntu with the ./${bin} script"
