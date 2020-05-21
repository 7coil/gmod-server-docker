# Docker for Garry's Mod
This is a Docker Compose setup for running Garry's Mod, with `unionfs-fuse`.

## How does `unionfs-fuse` work, and how is it used?
1. Imagine you have a Microsoft Word document open up, mirrored on two different screens.
2. To make changes to the document, I use sticky notes and stick them onto a single screen.
3. If you would like to make changes, you can write on top of a layer of glass in front of the screen.

While both screens have the same Word document (so the computer only stores a single document), the content on each screen is different.
The filesystem of `gmod-server-docker` is setup in a similar way to reduce the size on disk used.

Whenever a server wishes to look for a file, the following folders are explored in this order:
1. `/src/write/[instance]`
    - What the server can write to.
    - "The Whiteboard"
2. `/src/instance/[instance]`
    - Changes that deviate from the "common" folder. Used for configuring the specific instance.
    - "Sticky Notes"
3. `/src/common`
    - Changes that deviate from the base layer. Used for global configuration.
    - "Sticky Notes, but like you do it on both screens at the same time"
4. Garry's Mod Base Layer
    - "The single Word document mirrored on both screens"

Only a single base layer is required, allowing for a single copy of Garry's Mod to run multiple varied servers.

## How do I run this?
Get yourself a Linux machine, install Docker and run: `docker-compose up`

## How do I add an extra Garry's Mod server?
1. Fork this GitHub repository
2. Add an extra service into the `src/docker-compose.yml` file.
