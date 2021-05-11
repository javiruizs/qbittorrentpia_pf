#!/bin/bash

if [ -v port ]; then
    echo "
    #####################################################################
    #####################################################################
    #####################################################################
    #####################################################################

    Launching and configuring qBittorrent with the obtained port..."

    # Getting the previous port set up in the configuration file
    previousPort=$(cat /root/.config/qBittorrent/qBittorrent.conf | grep 'Connection\\PortRangeMin')
    echo "The previous port was ${previousPort#*=}"

    # Replacing the port in the config file with the newly obtained port
    sed -i -E 's,(Connection\\PortRangeMin=).*,\1'"$port"',g' /root/.config/qBittorrent/qBittorrent.conf

    # Checking that the port has been successfully updated
    newPort=$(cat /root/.config/qBittorrent/qBittorrent.conf | grep 'Connection\\PortRangeMin')
    echo "
    The current port is ${newPort#*=}

    Starting qBittorrent on port $WEBUI_PORT..."


    echo "

    qBittorrent should be now accessible through http://localhost:$WEBUI_PORT

    #####################################################################
    #####################################################################
    #####################################################################
    #####################################################################

    Trying to bind the port... "
fi

# Launching qBittorrent
qbittorrent-nox --webui-port=$WEBUI_PORT -d
