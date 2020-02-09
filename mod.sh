#!/bin/bash

server_root_dir="$HOME/.klei/DoNotStarveTogether"
mods_install_file="$HOME/dontstarvetogether_dedicated_server/mods/dedicated_server_mods_setup.lua"

function fail()
{
	echo Error: "$@" >&2
	exit 1
}
function check_for_file()
{
	if [ ! -e "$1" ]; then
		#fail "Missing file: $1"
		echo "你輸入的資料夾不存在"
		exit 1
	fi
}

function list_server()
{
	echo "======現有伺服器列表======"
	ls ${server_root_dir} -I Original_Server
	echo "=========================="
}
function list_mods()
{
	echo "======現有模組列表======"
	grep -v "^.*[-][-]" $mods_install_file | grep "ServerModSetup"
	echo "========================"
}
function install_mod()
{
	echo "-------------------"
	echo "------安裝MOD------"
	echo "-------------------"
	list_mods
	read -p "輸入MOD的編號：" mod_id
	echo "ServerModSetup(\"$mod_id\")" >> $mods_install_file
}
function delete_mod()
{
	echo "-------------------"
	echo "------刪除MOD------"
	echo "-------------------"
	list_mods
	read -p "輸入MOD的編號：" mod_id
	read -p "確認刪除？(y/n)：" delete_confirm
	if [ "${delete_confirm}" != "y" ]; then
		exit 1
	fi
	sed -i "/$mod_id/d" $mods_install_file
}
function mod_in_server()
{
	echo "-------------------------"
	echo "------MOD放進伺服器------"
	echo "-------------------------"
	list_server
	read -p "輸入伺服器資料夾名稱：" server_dir_name
	master_file_path="${server_root_dir}/${server_dir_name}/Master"
	caves_file_path="${server_root_dir}/${server_dir_name}/Caves"
	master_mod_file_path="${master_file_path}/modoverrides.lua"
	caves_mod_file_path="${caves_file_path}/modoverrides.lua"
	check_for_file "${master_mod_file_path}"
	
	echo "======伺服器內已有的MOD======"
	grep '[0-9][0-9]*' ${master_mod_file_path}
	echo "============================="
	read -p "輸入要加入的MOD編號：" mod_id
	if grep -q "${mod_id}" "${master_mod_file_path}"; then
		echo "此MOD已在伺服器內"
		exit 1
	else
		sed -i 's/}$/},/g' ${master_mod_file_path}
		sed -i '$i ["workshop-'${mod_id}'"]={ enabled=true }' ${master_mod_file_path}
		sed -i 's/^},$/}/g' ${master_mod_file_path}
		rm ${caves_mod_file_path}
		cp ${master_mod_file_path} ${caves_file_path}
	fi

}
function mod_out_server()
{
	echo "-------------------------"
	echo "------MOD移出伺服器------"
	echo "-------------------------"
	list_server
	read -p "輸入伺服器資料夾名稱：" server_dir_name
	master_file_path="${server_root_dir}/${server_dir_name}/Master"
	caves_file_path="${server_root_dir}/${server_dir_name}/Caves"
	master_mod_file_path="${master_file_path}/modoverrides.lua"
	caves_mod_file_path="${caves_file_path}/modoverrides.lua"
	check_for_file "${master_mod_file_path}"

	echo "======伺服器內已有的MOD======"
	grep '[0-9][0-9]*' ${master_mod_file_path}
	echo "============================="
	read -p "輸入要移出的MOD編號：" mod_id
	if grep -q "${mod_id}" "${master_mod_file_path}"; then
		read -p "確認移出MOD？(y/n)：" delete_confirm
		if [ "${delete_confirm}" != "y" ]; then
			exit 1
		fi
		sed -i "/${mod_id}/d" ${master_mod_file_path}
		sed -i 'x; ${s/},$/}/;p;x}; 1d' ${master_mod_file_path}
		rm ${caves_mod_file_path}
		cp ${master_mod_file_path} ${caves_file_path}
	else
		echo "伺服器內沒有這個MOD"
		exit 1
	fi


}

echo "1.安裝模組 2.刪除模組 3.模組放進伺服器 4.模組移出伺服器"
read -p "Option: " mod_option
case "${mod_option}" in
	1)
		install_mod
		;;
	2)
		delete_mod
		;;
	3)
		mod_in_server
		;;
	4)
		mod_out_server
		;;
	*)
		echo "沒這個選項.."
		;;
esac
