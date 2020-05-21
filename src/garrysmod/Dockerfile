FROM ubuntu:xenial
LABEL maintainer="github@leondrolio.com"

# Install required libraries
RUN apt-get update
RUN apt-get install wget lib32stdc++6 lib32gcc1 unionfs-fuse -y

# Install SteamCMD
WORKDIR /steamcmd
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
RUN tar -xvf steamcmd_linux.tar.gz

WORKDIR /gmod

# Create Folders
RUN mkdir base
RUN mkdir common
RUN mkdir specific
RUN mkdir union
RUN mkdir content
RUN mkdir content/css
RUN mkdir content/tf2

# Common: Files that are common to all Garry's Mod instances.
# Specific: Files that are associated to this Garry's Mod instance.
VOLUME /gmod/common
VOLUME /gmod/specific

# Download files from Steam
RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /gmod/base +app_update 4020 validate +quit
RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /gmod/content/css +app_update 232330 validate +quit
RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /gmod/content/tf2 +app_update 232250 validate +quit
ADD start.sh start.sh
EXPOSE 27015/udp
EXPOSE 27016/udp

# Default settings for the Garry's Mod Server
ENV PORT="27015"
ENV MAXPLAYERS="16"
ENV G_HOSTNAME="Garrys Mod for Docker"
ENV GAMEMODE="sandbox"
ENV MAP="gm_construct"

CMD ["/bin/sh", "/gmod/start.sh"]
