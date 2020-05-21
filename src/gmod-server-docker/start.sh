#!/bin/bash

# faketty () {
#   script -qfc "$(printf "'%s' " "$@")"
# }

unionfs-fuse -o cow /gmod/write=RW:/gmod/instance=RO:/gmod/common=RO:/gmod/base=RO /gmod/union
exec ./union/srcds_run -console -game garrysmod -norestart +exec "server.cfg" -port ${PORT} +maxplayers ${MAXPLAYERS} +hostname "${G_HOSTNAME}" +gamemode ${GAMEMODE} "${ARGS}" +map ${MAP}
