#!/bin/bash

function main_install()
{
	sudo dpkg --add-architecture i386
	sudo apt-get update
	sudo apt-get install lib32gcc1
	sudo apt-get install lib32stdc++6
	sudo apt-get install libcurl4-gnutls-dev:i386

	mkdir dontstarvetogether_dedicated_server
	mkdir steamcmd
	cd steamcmd/
	wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
	tar -xvzf steamcmd_linux.tar.gz
	install_dir="$HOME/dontstarvetogether_dedicated_server"
	./steamcmd.sh +force_install_dir "$install_dir" +login anonymous +app_update 343050 validate +quit
	cd ~
	mkdir .klei
	mkdir .klei/DoNotStarveTogether
	mv Original_Server.tar .klei/DoNotStarveTogether/
	cd .klei/DoNotStarveTogether/
	tar xvf Original_Server.tar
	rm Original_Server.tar
	cd ~
}
function assign_token()
{
	cd ~/.klei/DoNotStarveTogether/Original_Server
	read -p "輸入你的Token: " server_token
	echo "${server_token}" >> cluster_token.txt
	echo "已寫入.."
	cd ~
}

echo "1.安裝主要元件 2.輸入TOKEN"
read -p "Option: " main_option
case "${main_option}" in
	1)
		main_install
		;;
	2)
		assign_token
		;;
	*)
		echo "沒這個選項.."
		;;
esac
