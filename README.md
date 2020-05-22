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

## Technical Support
For technical support, contact me on [Discord](https://discord.gg/aJy34vE)

## Licence
This software fudge is licenced under the MIT licence.
