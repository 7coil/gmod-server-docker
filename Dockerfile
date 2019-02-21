FROM ubuntu:bionic

LABEL maintainber="leondrolio@gmail.com"

# Install required libraries
RUN apt-get update
RUN apt-get install wget lib32stdc++6 lib32gcc1 unionfs-fuse -y

# Install SteamCMD
RUN mkdir /steamcmd
WORKDIR /steamcmd
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
RUN tar -xvf steamcmd_linux.tar.gz
WORKDIR /

# Install Garry's Mod
RUN mkdir /gmod-base
RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /gmod-base +app_update 4020 validate +quit

# Install additional content
RUN mkdir /content
RUN mkdir /content/css
RUN mkdir /content/tf2
RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /content/css +app_update 232330 validate +quit
RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /content/tf2 +app_update 232250 validate +quit
ADD mount.cfg /gmod-base/garrysmod/cfg/mount.cfg

# Set up union
RUN mkdir /gmod-volume
VOLUME /gmod-volume
RUN mkdir /gmod-union

# Container
ADD start-server.sh /start-server.sh
EXPOSE 27015/udp

# Default settings for the Garry's Mod Server
ENV PORT="27015"
ENV MAXPLAYERS="16"
ENV G_HOSTNAME="Garry\'s Mod for Docker"
ENV GAMEMODE="sandbox"
ENV MAP="gm_construct"

CMD ["/bin/sh", "/start-server.sh"]
