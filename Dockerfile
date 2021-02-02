FROM ubuntu:20.04

# Set workdir
WORKDIR /root

# Configuring Timezone
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# First update and upgrade
RUN apt update
RUN apt upgrade -y

# Installing necessary packages so we can add the qbittorrent repo later
RUN apt install -y openvpn net-tools curl wget jq gnupg

# Installing qbittorrent
RUN echo "deb http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu focal main" >> /etc/apt/sources.list
RUN echo "# deb-src http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu focal main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 401E8827DA4E93E44C7D01E6D35164147CA69FC4
RUN apt-get update
RUN apt-get install qbittorrent-nox qbittorrent -y

# Creating download directory
RUN mkdir -p /share/Download

# Copying qBittorrent config file
COPY qBittorrent.conf /root/.config/qBittorrent/

# Copying manual-connections-1.1.0
COPY scripts/ /root/scripts/

RUN find scripts/ -type f -name "*.sh" -exec chmod +x {} \;