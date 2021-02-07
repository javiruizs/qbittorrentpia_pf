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
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt install -y software-properties-common openvpn net-tools curl wget jq gnupg wireguard build-essential

# Installing resolvconf, needed for WireGuard
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections
RUN apt install resolvconf -y

# Installing qbittorrent
RUN add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
RUN apt-get update
RUN apt-get install qbittorrent-nox -y

# Creating download directory
RUN mkdir -p /share/Download

# Copying qBittorrent config file
COPY qBittorrent.conf /root/.config/qBittorrent/

# Copying manual-connections-1.1.0
COPY scripts/ /root/scripts/

RUN find scripts/ -type f -name "*.sh" -exec chmod +x {} \;