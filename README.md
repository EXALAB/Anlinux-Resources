This is the place where all the images and scripts are stored. If you are looking for the main application, please visit [here](https://github.com/EXALAB/AnLinux-App)

To open an issue, please visit [here](https://github.com/EXALAB/AnLinux-App/issues)



## Bootstraping System

Note: Only [Ubuntu](https://www.ubuntu.com/), [Debian](https://www.debian.org/), [Kali](https://www.kali.org/), [Parrot Security OS](https://www.parrotsec.org/), [BackBox](https://www.backbox.org) are bootstrap using the script, others are official image without modification.

Script located at Scripts/Bootstrap are used to bootstrap the system.

You will need to install some package first:

> sudo apt-get install qemu-user-static debian-archive-keyring debootstrap

Then go to [Bootstrap](https://github.com/EXALAB/Anlinux-Resources/tree/master/Scripts/Bootstrap) and download the bootstrap.sh script. (It is important to follow instructions before running bootstrap.sh if there any.)

To bootstrap a system, simply run:

> ./bootstrap.sh architecture /path/to/bootstrap
   
For example: 

> ./bootstrap.sh armhf /home/user/ubuntu/armhf


# To install this in Termux use the below command=
```ShellSession
hash -r && wget https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/Installer/Kali/kali.sh && bash kali.sh && ./start-kali.sh && apt install git apt-utils figlet procps -y && apt-get update --fix-missing && neofetch
```
