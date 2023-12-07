Before running the sh script, import [parrotsec.gpg](https://deb.parrot.sh/parrot/misc/parrotsec.gpg) by running this command:

`wget -qO - https://deb.parrot.sh/parrot/misc/parrotsec.gpg | gpg --import --no-default-keyring --keyring /etc/apt/trusted.gpg.d/parrotsec.gpg`

Then download this file [parrot](https://github.com/EXALAB/Anlinux-Resources/tree/master/Scripts/Bootstrap/Parrot/parrot), then put [parrot](https://github.com/EXALAB/Anlinux-Resources/tree/master/Scripts/Bootstrap/Parrot/parrot) under /usr/share/debootstrap/scripts .