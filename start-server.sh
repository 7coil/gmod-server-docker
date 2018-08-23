#!/bin/bash
echo Welcome to Garry\'s Mod!

if [ -n "$UNION" ]; then
  unionfs-fuse -o cow /gmod-volume=RW:/gmod-base=RO /gmod-union
  EXECUTABLE = "/gmod-union/srcds_run"
else
  EXECUTABLE = "/gmod-base/srcds_run"
fi

while true; do
  ${EXECUTABLE} -game garrysmod -norestart -port ${PORT} +maxplayers ${MAXPLAYERS} +hostname "${G_HOSTNAME}" +gamemode ${GAMEMODE} "${ARGS}" +map ${MAP}
done
