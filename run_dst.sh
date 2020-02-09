#!/bin/bash
if [ $# -ne 1 ]; then
        echo "請輸入下列伺服器資料夾名稱於後方.."
        ls ~/.klei/DoNotStarveTogether/ -I Original_Server
        exit
fi
cluster_name=$1
steamcmd_dir="$HOME/steamcmd"
install_dir="$HOME/dontstarvetogether_dedicated_server"
dontstarve_dir="$HOME/.klei/DoNotStarveTogether"
function fail()
{
        echo Error: "$@" >&2
        exit 1
}
function check_for_file()
{
        if [ ! -e "$1" ]; then
                fail "Missing file: $1"
        fi
}
cd "$steamcmd_dir" || fail "Missing $steamcmd_dir directory!"
check_for_file "steamcmd.sh"
check_for_file "$dontstarve_dir/$cluster_name/cluster.ini"
check_for_file "$dontstarve_dir/$cluster_name/cluster_token.txt"
check_for_file "$dontstarve_dir/$cluster_name/Master/server.ini"
check_for_file "$dontstarve_dir/$cluster_name/Caves/server.ini"

check_for_file "$install_dir/bin"
cd "$install_dir/bin" || fail
run_shared=(./dontstarve_dedicated_server_nullrenderer)
run_shared+=(-console)
run_shared+=(-cluster "$cluster_name")
run_shared+=(-monitor_parent_process $$)
"${run_shared[@]}" -shard Caves  | sed 's/^/Caves:  /' &
"${run_shared[@]}" -shard Master | sed 's/^/Master: /'