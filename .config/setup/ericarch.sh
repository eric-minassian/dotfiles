#!/bin/bash

# Install RUST for Paru
sudo pacman -Sy --needed --noconfirm rustup
rustup default stable

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

# Setup pacman.conf
sudo sed -i 's/#Color/Color/g' /etc/pacman.conf

paru -Sy --needed --noconfirm - < packages-clean.txt

# Setup Shell
chsh -s /bin/zsh

# Setup CUPS
sudo systemctl enable --now cups.service

# Setup Docker
sudo systemctl enable --now docker.socket
sudo usermod -aG docker $USER

# Setup Virtmanager
paru -S iptables-nft
sudo systemctl enable --now libvirtd.service
sudo usermod -aG libvirt $USER
sudo sed -i 's/^#unix_sock_group = .*/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf
sudo sed -i 's/^#unix_sock_rw_perms = .*/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf
sudo sed -i "s/#user = \"libvirt-qemu\"/user = \"$USER\"/" /etc/libvirt/qemu.conf
sudo sed -i "s/#group = \"libvirt-qemu\"/group = \"$USER\"/" /etc/libvirt/qemu.conf

# Setup Pipewire
systemctl enable --user pipewire-pulse.service

# Setup Github-Cli
# gh auth login

# Final Steps
cd ~/dotfiles
stow .
cd ~
rm -rf ~/paru
mkdir projects
