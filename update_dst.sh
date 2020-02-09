#!/bin/bash

steamcmd_dir="$HOME/steamcmd"
install_dir="$HOME/dontstarvetogether_dedicated_server"

cd "$steamcmd_dir" || fail "Missing $steamcmd_dir directory!"
./steamcmd.sh +force_install_dir "$install_dir" +login anonymous +app_update 343050 validate +quit

echo "更新完了.."