#!/bin/bash

#Get the necessary components
apt-get update
apt-get install openssh-server -y

#Setup the necessary files
wget https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/SSH/Apt/sshd_config -P /etc/ssh

echo "You can now start OpenSSH Server by running /etc/init.d/ssh start"
echo " "
echo "The Open Server will be started at 127.0.0.1:22"
