#!/bin/bash

server_root_dir="$HOME/.klei/DoNotStarveTogether"

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

function create_server()
{
	echo "------創建伺服器------"
	read -p "伺服器資料夾名稱：" server_dir_name
	read -p "房間名稱：" server_name
	read -p "房間描述：" server_description
	read -p "房間密碼(不設密碼就直接Enter)：" server_password
	read -p "房間人數：" server_players
	read -p "確認創建？(y/n)：" create_confirm
	if [ "${create_confirm}" != "y" ]; then
		exit 1
	fi

	cp -R ${server_root_dir}/Original_Server ${server_root_dir}/${server_dir_name}
	ini_file_path="${server_root_dir}/${server_dir_name}/cluster.ini"
	sed -i "/cluster_name/s/$/${server_name}/" ${ini_file_path}
	sed -i "/cluster_description/s/$/${server_description}/" ${ini_file_path}
	sed -i "/cluster_password/s/$/${server_password}/" ${ini_file_path}
	sed -i "/max_players/s/$/${server_players}/" ${ini_file_path}
}
function config_server()
{
	echo "------修改伺服器------"
	read -p "輸入想修改的資料夾：" server_dir_name
	ini_file_path="${server_root_dir}/${server_dir_name}/cluster.ini"
	check_for_file "$ini_file_path"
	echo "--------------------------"
	echo "------當前伺服器資訊------"
	grep "cluster_name" ${ini_file_path}
	grep "cluster_description" ${ini_file_path}
	grep "cluster_password" ${ini_file_path}
	grep "max_players" ${ini_file_path}
	echo "--------------------------"
	
	read -p "新的房間名稱：" server_name
	read -p "新的房間描述：" server_description
	read -p "新的房間密碼(不設就直接Enter)：" server_password
	read -p "新的房間人數：" server_players
	read -p "確認修改？(y/n)：" config_confirm
	if [ "${config_confirm}" != "y" ]; then
		exit 1
	fi

	sed -i "/cluster_name/s/\=.*$/\= ${server_name}/" ${ini_file_path}
	sed -i "/cluster_description/s/\=.*$/\= ${server_description}/" ${ini_file_path}
	sed -i "/cluster_password/s/\=.*$/\= ${server_password}/" ${ini_file_path}
	sed -i "/max_players/s/\=.*$/\= ${server_players}/" ${ini_file_path}

}
function delete_server()
{
	echo "------刪除伺服器------"
	read -p "輸入想刪除的資料夾：" server_dir_name
	server_dir_path="${server_root_dir}/${server_dir_name}"
	check_for_file "$server_dir_path"
	read -p "確認刪除？(y/n)：" delete_confirm
	if [ "${delete_confirm}" != "y" ]; then
		exit 1
	fi
	rm -rf ${server_dir_path}
}

echo "======現有伺服器列表======"
ls ${server_root_dir} -I Original_Server
echo "=========================="
echo "1.創建伺服器 2.修改伺服器 3.刪除伺服器"
read -p "Option: " server_option

case "${server_option}" in
	1)
		create_server
		;;
	2)
		config_server
		;;
	3)
		delete_server
		;;
	*)
		echo "沒這個選項.."
		;;
esac
