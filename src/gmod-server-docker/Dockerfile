FROM ubuntu:xenial
LABEL maintainer="github@leondrolio.com"

# Install required libraries
RUN apt-get update
RUN apt-get install wget lib32stdc++6 lib32gcc1 unionfs-fuse -y

# Install SteamCMD
WORKDIR /steamcmd
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
RUN tar -xvf steamcmd_linux.tar.gz

# Download files from Steam
RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /gmod/base +app_update 4020 validate +quit
RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /gmod/content/css +app_update 232330 validate +quit
RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /gmod/content/tf2 +app_update 232250 validate +quit

# Create Folders
WORKDIR /gmod
# RUN mkdir base
RUN mkdir write
RUN mkdir instance
RUN mkdir common
RUN mkdir union
# RUN mkdir content
# RUN mkdir content/css
# RUN mkdir content/tf2

# Order of Files (where to look first?!)
# 1. write - The place where data for this server is written to.
# 2. instance - The place where data for this server can be read from, and commited to Git.
# 3. common - The place where data for all servers can be read from
# 4. base - Garry's Mod (nothing else!)
# These are merged using unionfs-fuse into the /gmod/union folder.
VOLUME /gmod/write
VOLUME /gmod/instance
VOLUME /gmod/common

# Add start script
ADD start.sh start.sh
EXPOSE 27015/udp

# Default settings for the Garry's Mod Server
ENV PORT="27015"
ENV MAXPLAYERS="16"
ENV G_HOSTNAME="Garrys Mod for Docker"
ENV GAMEMODE="sandbox"
ENV MAP="gm_construct"

CMD ["/bin/sh", "/gmod/start.sh"]
