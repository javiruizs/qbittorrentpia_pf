# vuvucela-torrencial
Docker image that combines qBittorrent and Private Internet Acces (PIA) with port forwarding.

## Brief descritpion
This is a simple project. It basically combines the [manual scritps](https://www.privateinternetaccess.com/helpdesk/kb/articles/manual-connection-and-port-forwarding-scripts) ellaborated by PIA and published on [GitHub](https://github.com/pia-foss/manual-connections), with the Ubuntu 20.04 Docker image and the latest available stable qBittorrent release. **For this to work you need an actvie PIA subscription**.

## Tested environments
As of now, I've tested this set up on my Windows machine with Docker running on WSL2. It works, yet **only with OpenVPN**. It seems that Wireguard is not supported by the kernel used here. It sais "unsupported protocol".
I'm trying to make it work for the Container Station of my QNAS server. As soon as I make some progress, I'll post it on here.

## Versions of elements used in the image
+ manual-connections: [v2.0.0](https://github.com/pia-foss/manual-connections/releases/tag/v2.0.0)
+ qBittorrent: latest available version on [qbittorrent-stable repository](https://launchpad.net/~qbittorrent-team/+archive/ubuntu/qbittorrent-stable)

## What's different from the original manual-connections release?
In order to make the port forwarding functionality to work, I had to modify the [port_forwarding.sh](scripts/port_forwarding.sh) script by setting the `Connection\PortRangeMin` value of the [qBittorrent.conf](qBittorrent.conf) file to the obtained port and creating a deamon of qBittorrent on the desired port.

## Customizing global variables in the docker-compose.yml file
You need to set your credentials in the docker-compose.yml file beforehand. You can also change few of the default configurations of the PIA scripts. Check the README on their git so you know how everything works.

## How to deploy

### Windows 10 and docker running on WSL
Clone the repo and modify the compose file with your credentials and according to your preferences.
Then, simply run `docker-compose up -d`. To remove the app: `docker-compose down`.

## How to build and deploy

### Windows 10 and docker running on WSL
If you don't want to clone the existing image on docker-hub, you can also build the image yourself on your computer.
To do so, you must change the following lines:
```YML
image: javiruizs/qbittorentpia
```
...to...
```YML
build:
    context: .
    dockerfile: Dockerfile
```

Then, you can copy and paste: `docker-compose build && docker-compose up -d`