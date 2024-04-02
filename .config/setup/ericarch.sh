#!/bin/bash

install_packages() {
	# Install AUR Helper (Paru)
	sudo pacman -Sy --need --noconfirm rustup
	rustup default stable
	cd ~
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si --noconfirm
	
	# Install Packages
	cd ~/dotfiles/.config/setup
	cp packages.sh packages-clean.txt
	sed -i '/^#/d;/^$/d' packages-clean.txt
	paru -Sy --needed --noconfirm - < packages-clean.txt
}

configure_shell() {
	chsh -s /bin/zsh
}

configure_cups() {
	sudo systemctl enable --now cups.service
}

configure_docker() {
	sudo systemctl enable --now docker.socket
	sudo usermod -aG docker $USER
}

configure_virtmanager() {
	paru -S iptables-nft virt-manager qemu-desktop dnsmasq --noconfirm
	sudo systemctl enable --now libvirtd.service
	sudo usermod -aG libvirt $USER
	sudo sed -i 's/^#unix_sock_group = .*/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf
	sudo sed -i 's/^#unix_sock_rw_perms = .*/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf
	sudo sed -i "s/#user = \"libvirt-qemu\"/user = \"$USER\"/" /etc/libvirt/qemu.conf
	sudo sed -i "s/#group = \"libvirt-qemu\"/group = \"$USER\"/" /etc/libvirt/qemu.conf
}

configure_pipewire() {
	systemctl enable --user pipewire-pulse.service
}

configure_ui() {
	sudo sed -i 's/#Color/Color/g' /etc/pacman.conf
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
}

cleanup() {
	cd ~/dotfiles
	stow .
	cd ~
	rm -rf ~/paru
	mkdir projects
}

main() {
	read -p "Configure Docker? (y/n): " docker
	read -p "Configure Virtualization? (y/n): " virt


	install_packages
	configure_shell
	configure_cups

	if [ "$docker" == "y" ]; then
		configure_docker
	fi

	if [ "$virt" == "y" ]; then
		configure_virtmanager
	fi

	configure_pipewire
	configure_ui
	cleanup
}

main


