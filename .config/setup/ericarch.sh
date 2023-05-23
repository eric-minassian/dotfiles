#!/bin/bash

# Move Dotfiles to Homefolder
cd ~
cp -rT ~/dotfiles ~

# Setup AUR Helper (Paru)
cd ~
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

# Install Packages
cd ~/dotfiles/.config/setup

# Clean Packages.txt
cp packages.sh packages-clean.txt
sed -i '/^#/d;/^$/d' packages-clean.txt

paru -Sy --needed --noconfirm - < packages-clean.txt

# Setup Shell
chsh -s /bin/zsh

# Setup CUPS
sudo systemctl enable --now cups.service

# Setup Docker
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER

# Setup Virtmanager
paru -S iptables-nft
sudo systemctl enable --now libvirtd.service
sudo usermod -aG libvirt $USER
sudo sed -i 's/^#unix_sock_group = .*/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf
sudo sed -i 's/^#unix_sock_rw_perms = .*/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf
sudo sed -i "s/#user = \"libvirt-qemu\"/user = \"$USER\"/" /etc/libvirt/qemu.conf
sudo sed -i "s/#group = \"libvirt-qemu\"/group = \"$USER\"/" /etc/libvirt/qemu.conf


# Setup Github-Cli
gh auth login

# Final Steps
cd ~
rm -rf ~/dotfiles
rm -rf ~/paru
mkdir projects
