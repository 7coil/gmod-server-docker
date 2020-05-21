#!/bin/bash

faketty () {
  script -qfc "$(printf "'%s' " "$@")"
}

unionfs-fuse -o cow /gmod/specific=RW:/gmod/common=RO:/gmod/base=RO /gmod/union
faketty ./union/srcds_run -console -game garrysmod -norestart +exec "server.cfg" -port ${PORT} +maxplayers ${MAXPLAYERS} +hostname "${G_HOSTNAME}" +gamemode ${GAMEMODE} +map ${MAP}

