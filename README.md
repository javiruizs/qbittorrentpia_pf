# qBittorrentPIA_PF
Docker image that combines qBittorrent and Private Internet Acces (PIA) with port forwarding.

## Brief descritpion
This is a simple project. It basically combines the [manual scritps](https://www.privateinternetaccess.com/helpdesk/kb/articles/manual-connection-and-port-forwarding-scripts) elaborated by PIA and published to [GitHub](https://github.com/pia-foss/manual-connections), with the Ubuntu 20.04 Docker image and the latest available stable qBittorrent release. **For this to work you need an actvie PIA subscription**.

## Tested environments

### Windows 10
|||
|---|---|
|Environment|Windows 10 + WSL 2|
|Working protocols|Only OpenVPN.|
|Deploying|As described below.|

### Ubuntu 20.04 LTS
|||
|---|---|
|Environment|Ubuntu 20.04 LTS VM|
|Working protocols|Both OpenVPN and WireGuard.|
|Deploying|As described below. **Note:** In order to make WireGuard work, container must be run in privileged mode.|

### QTS 4.2.5
|||
|---|---|
|Environment|Container Station running on QNAP NAS on QTS 4.2.5|
|Working protocols|Only OpenVPN.|
|Deploying|Only manual setup has been tested. Working on automatization.|

## Versions of elements used in the image
+ manual-connections: [v2.0.0](https://github.com/pia-foss/manual-connections/releases/tag/v2.0.0)
+ qBittorrent: latest available version on [qbittorrent-stable repository](https://launchpad.net/~qbittorrent-team/+archive/ubuntu/qbittorrent-stable)

## What's different from the original manual-connections release?
In order to use the forwarded port within qBittorrent, I had to modify the [port_forwarding.sh](scripts/port_forwarding.sh) script by setting it to the `Connection\PortRangeMin` entry of the [qBittorrent.conf](qBittorrent.conf) file. Since the port forwarding functionality requires a regular call to the API, I couldn't just launch the script in the background.

This is the code extract I added:
```bash
echo "
#####################################################################
#####################################################################
#####################################################################
#####################################################################

Launching and configuring qBittorrent with the obtained port..."

# Getting the previous port set up in the configuration file
previousPort|$(cat /root/.config/qBittorrent/qBittorrent.conf | grep 'Connection\\PortRangeMin')
echo "The previous port was ${previousPort#*|}"

# Replacing the port in the config file with the newly obtained port
sed -i -E 's,(Connection\\PortRangeMin|).*,\1'"$port"',g' /root/.config/qBittorrent/qBittorrent.conf

# Checking that the port has been successfully updated
newPort|$(cat /root/.config/qBittorrent/qBittorrent.conf | grep 'Connection\\PortRangeMin')
echo "
The current port is ${newPort#*|}

Starting qBittorrent on port $WEBUI_PORT..."

# Launching qBittorrent
qbittorrent-nox --webui-port|$WEBUI_PORT -d

echo "

qBittorrent should be now accessible through http://localhost:$WEBUI_PORT

#####################################################################
#####################################################################
#####################################################################
#####################################################################
```

## Before you deploy
You need to set your credentials in the docker-compose.yml file (PIA_USER and PIA_PASS).

If you want, you can also change some of the connection behavior through these variables (copied and summarized from [here](https://github.com/pia-foss/manual-connections#automated-setup)):

|Variable|Values|Ussage|
|----|----|----|
|PIA_DNS|`true` or `false`|Enforces/Disables using PIA DNS addresses.|
|PIA_PF|`true` or `false`|Enables/Disables port forwarding|
|MAX_LATENCY|`float`, in seconds, e.g.: 0.05|Max latency to consider when choosing VPN destination automatically.|
|AUTOCONNECT|`true` or `false`|If set to true, it "will test for and select the server with the lowest latency" and "will override PREFERRED_REGION".|
|PREFERRED_REGION|e.g.: spain|"The region ID for a PIA server." To get a complete list of the available regions, execute the `sudo MAX_LATENCY=10 ./get_region.sh` and you'll get the whole list.|
|VPN_PROTOCOL|`wireguard`, `openvpn`, `openvpn_udp_standard`, `openvpn_tcp/udp_standad/strong`|Desired VPN protocol to be used. "openvpn will default to openvpn_udp_standard"|
|DISABLE_IPV6|`yes` or `no`|Disables/Enables IPv6 connectivity. Either PIA or OpenVPN disencourages the usage of IPv6 to prevent DNS leaking.|
|WEBUI_PORT|`int`, e.g.: 8888|The port from wich you will access qBittorrent via browser. **IMPORTANT**: If you change this value, you must not forget to change the port mapping on the YML file, as well.|

## How to deploy
The image resulting of the Dockerfile in this repo has been published to Docker Hub. There's no need to build the image first.
Clone the repo and modify the compose file with your credentials and according to your preferences.
Then, simply run `docker-compose up -d`. To remove the app: `docker-compose down`.

## How to build and deploy

If you would rather build the image yourself you simply need to change:
```YML
image: javiruizs/qbittorentpia
```
...to...
```YML
build:
    context: .
    dockerfile: Dockerfile
```
...in the [docker-compose.yml](docker-compose.yml) file.

Then, you can run: `docker-compose build && docker-compose up -d`

## Access

Navigate to http://localhost:8888 (or the port you have specified). The credentials are as default by qBittorrent:
* user: admin
* password: adminadmin

# Thanks

If PIA wouldn't have published these scripts, I wouldn't have come up with the whole idea. So, all my thanks and creds to them!

# License

This project is licensed under the MIT (Expat) license, which can be found [here](LICENSE).