# Docker for Garry's Mod
This is a set of Dockerfile and scripts that will create a container that runs a [Garry's Mod](https://gmod.facepunch.com/) Server. 

The container optionally uses [unionfs-fuse](https://github.com/rpodgorny/unionfs-fuse) to make a union filesystem layering `/gmod-volume` over `/gmod-base`, where the server is installed. 
`/gmod-volume` is exposed as a docker volume. 
This allows you to customize the server and/or run multiple servers with different configs without needing a copy of the (~3GB) base server for each one. 
Any file you put in `/gmod-volume` will override the files in `/gmod-base`, and attempting to write to any file in `/gmod-base` that doesn't exist in `/gmod-volume` will instead copy it to `/gmod-volume` and make the changes there (Copy-On-Write). 
You can also create a `start-server.sh` in the volume to customize what happens when the server is started (for instance, you may want to automatically update it, or use a more sophisticated crash detection system).

Using unionfs-fuse requires the container to be run with `--privileged=true` and the environment variable `UNION` to be set. 

## Examples
```bash
# Start a server on port 27015 without using the union filesystem
docker run -d -p 27015:27015/udp suchipi/gmod-server

# Start a server on an automatically allocated port, mounting the contents of /home/srcds/gmod-1 over the internal base
docker run --privileged=true -d -P -e UNION=1 -v /home/srcds/gmod-1:/gmod-volume suchipi/gmod-server

# Start a Melonbomber server on port 27016, mounting the contents of /home/gmod-server-docker/gmod-example over the base
docker run \
  --privileged=true \
  -v /home/gmod-server-docker/gmod-example:/gmod-volume \ # Copy files from the "gmod-example" folder to the "gmod-volume" for custom settings and addons
  -it -p 27016:27016/udp -e PORT=27016 \ # Set the port to 27016.
  -e ARGS="+host_workshop_collection 1489511514" \ # Add extra arguments to the Garry's Mod server
  -e GAMEMODE=melonbomber \ # Set the gamemode of the server
  -e UNION=true \ # Tell the script to enable the union file system
  gmod-server-docker:latest
```

## Notes/Todo
You can set the environment variables MAXPLAYERS, MAP, GAMEMODE, G_HOSTNAME, and ARGS to change the startup arguments to the srcds_run command. For example:

`docker run -d -P -e MAXPLAYERS=32 -e MAP=gm_flatgrass -e GAMEMODE=my_cool_gamemode -e G_HOSTNAME="My awesome gmod server" -e ARGS="-insecure +exec something.cfg" suchipi/gmod-server`

The Source Engine doesn't seem to find out which port it's *actually* running on, so it tells the master servers that it's running on 27015 (or whatever `-port` you specified at runtime) even if you assign with `-p` dynamically.
I've explored several potential solutions to this but the bottom line is that the Source Engine Dedicated Server wasn't really set up with this type of NATing in mind (or maybe, for that matter, any type of NAT).
If you want this piece to work properly, you should probably just use the same port on the docker host as within the container.

`build.sh` and `run.sh` are just convenience scripts; they aren't used by the Dockerfile.
