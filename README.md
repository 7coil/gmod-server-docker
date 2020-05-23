# Full Stack Garry's Mod
- ULX groups, shares and bans shared between servers
- Uses RethinkDB for ultimate "Web 2.0" experience
- Uses `unionfs-fuse` in conjunction with Docker volumes to decrease per-server file size usage
- Production Ready

## How to use
- Place content common to all servers in the `/src/common/garrysmod` folder
- Place content common to individual servers in the `/src/instance/[instance]/garrysmod` folder
- Populate `/src/secrets/steam_server_key.json`
    - An example file in `/src/secrets-example/` is provided.
- Run `docker-compose up`

## Services Overview
Name                    | Ports                                            | Description
----------------------- | ------------------------------------------------ | ------------------
rethinkdb               | `127.0.0.1:8080`                                 | The database which stores data for ULX bans, and ULIB users and groups.
rethinkdb_setup         |                                                  | A start-up script which creates tables in the database if they do not exist.
gmod_database_webserver | `127.0.0.1:8000`, `gmod_database_webserver:80`   | A webserver which accepts HTTP requests to manipulate the database. Not password protected (so don't expose this to the internet).
terrortown              | `0.0.0.0:27018`                                  | Trouble in Terrorist Town server.
hideandseek             | `0.0.0.0:27017`                                  | Hide and Seek server.
melonbomber             | `0.0.0.0:27016`                                  | Melonbomber server.

## Technical Support
For technical support, contact me on [Discord](https://discord.gg/aJy34vE)

## Licence
This software fudge is licenced under the MIT licence.
