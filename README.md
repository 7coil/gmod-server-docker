# The Beacon Garry's Mod

Featuring:
- ULX groups, shares and bans shared between servers
- Uses RethinkDB for ultimate "Web 2.0" experience
- Uses `unionfs-fuse` in conjunction with Docker volumes to decrease per-server file size usage
- Production Ready

## How to use
- Populate `/src/secrets/steam_server_key.json`
    - An example file in `/src/secrets-example/` is provided.
    - Generate keys [from Steam's website](https://steamcommunity.com/dev/managegameservers)
- Run `docker-compose up`

## Adding a new Server
To add a new gamemode to the stack, copy and change some of the settings in the `docker-compose.yml` file.

```yaml
container_name: # The name of the container. Must be unique between all containers
  build: gmod-server-docker
  ports:
    - 27016:27016/udp # Port to listen on. Port forwarding to different port NOT allowed.
  volumes:
    - ./write/container_name:/gmod/write # The place where unionfs-fuse writes to for server specific data
    - ./instance/container_name:/gmod/instance # Your server configuration and addons for this specific server
    - ./common:/gmod/common # Server configuration and addons for all servers
  privileged: true
  stop_grace_period: 30s
  environment:
    PORT: 27016 # Use same port number as above 
    MAP: mb_melonbomber # Map to load to
    GAMEMODE: melonbomber # Name of the gamemode
    WORKSHOP: 1489511514 # ID of the workshop collection to download items from
    STEAM_SERVER_KEY: container_name # The "key" of the Steam Server API key. Must match a key in `/src/secrets/steam_server_key.json`
  secrets:
    - steam_server_key
  depends_on:
    - gmod_database_webserver
  restart: always
```

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
