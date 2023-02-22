#!/bin/sh

# Daniel's Bootstrapping Script
# Liscence: GNU GPLv3

introduction() {
	echo "Daniel's Bootstrap Script"
	echo
	echo "This scripts contains some of the packages I use and some of my config files. Hope you find it useful as well!"
	echo "Run as root, and update your system before continuing!"
	echo
}


#Script to update
updater() {
	echo "Updating system..."
	sudo apt upgrade && sudo apt update;
        echo
        echo "Update finished!"
	echo	
}

proginstall() {
	# Add repositories
	echo "Installing Programs..."
	echo "deb http://ftp.us.debian.org/debian/ bullseye main contrib non-free
deb-src http://ftp.us.debian.org/debian/ bullseye main contrib non-free

deb http://ftp.us.debian.org/debian/ bullseye-updates main contrib non-free

deb http://deb.debian.org/ bullseye-security main contrib non-free
deb-src http://deb.debian.org/ bullseye-security main contrib non-free" >> /etc/apt/sources.list

	sudo apt update

	# Download files from programs.txt
	programs="programs.txt"
	Lines=$(cat $programs)
	for Line in $Lines
	do
		echo "Installing $Line"
		sudo apt install $Line -y 
	done

	# Install brave browser
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt update
	sudo apt install brave-browser -y

	echo
	echo "Programs installed!";
	echo
}

gamesinstall() {
	echo "Installing games..."
	whiptail --title "Games"\
		--msgbox "Installing Games"
	games="games.txt"
		Lines=$(cat $games)
		for Line in $Lines
	do
		echo "Installing $Line"
		sudo apt install $Line -y 
	done

	#New path variable for pip install
	echo export PATH+"$HOME/.local/bin:$PATH" >> ~/.bashrc
	curl -LJO https://github.com/abw333/dominoes 
	sed $HOME/.local.bin/dominoes
	sed -i "1s/.*/#!/usr/bin/python3/" $HOME/.local/bin/dominoes/domino;
	echo
	echo "Games installed!"
	echo
}

proguninstall() {
	programs="programs.txt"
	Lines=$(cat $programs)
	for Line in $Lines
	do
		echo "Installing $Line"
		sudo apt remove $Line -y 
	done
	echo "Uninstalled all programs!";
}

# Create desired filestructure
createfs() {
	echo "Making file structure..."
	sudo mkdir Downloads Documents Images Scripts Music ~/Documents/eBooks ~/Images/Wallpapers;
	echo
	echo "File structure created!"
	echo
}

#Move config files
mvconfig() {
	echo "Moving config files..."
	sudo mv ../.config/.Xresources  ~/ 
	sudo mv ../.config/.bashrc  ~/ 
	curl -Ls "https://raw.githubusercontent.com/drivera021/drive/master/.config/" > "/home/$name/.config/";
	echo
	echo "Files moved!"
	echo
}



introduction
	PS3="Please select your choice: "
	options=("Install + Config" "Games Install" "Uninstall")
	select opt in "${options[@]}"
	do
		case $opt in 
			"Install + Config")
				updater
				proginstall
				mvconfig
	     			;;
			"Games Install")
				gamesinstall
				;;		
			"Uninstall")
				proguninstall
				;;
			"Exit")
				break
				;;
		esac
	done
echo "All done!"
