#!/bin/bash
set -e
##################################################################################
echo "###########################################################################"
echo "##      This script assumes you have the linux kernel running        ##"
echo "###########################################################################"

sudo pacman -S --noconfirm --needed virtualbox
sudo pacman -S --needed --noconfirm virtualbox-host-dkms
sudo usermod -aG vboxusers $USER
sudo modprobe vboxdrv

# vboxmanage -v | cut -dr -f1 # sprawdzenie vbox 7.02.12

#Pobrać odpowiedni guest extention pack

# wget https://download.virtualbox.org/virtualbox/7.0.12/Oracle_VM_VirtualBox_Extension_Pack-7.0.12.vbox-extpack

# sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-7.0.12.vbox-extpack

#vboxmanage list extpacks

echo "###########################################################################"
echo "##      Removing all the messages virtualbox produces         ##"
echo "###########################################################################"
VBoxManage setextradata global GUI/SuppressMessages "all"

echo "###########################################################################"
echo "#########               You have to reboot.                       #########"
echo "###########################################################################"
