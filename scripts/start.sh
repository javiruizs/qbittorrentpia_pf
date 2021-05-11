#!/bin/bash

# Configuring Timezone

cd /scripts

echo "Updating..."
apt update 2>&1 1>/dev/null
if [ $? -ne 0 ]; then
    echo "Updating failed."
else
    echo "Updating succeded."
fi

echo "Upgrading..."
apt upgrade -y 2>&1 1>/dev/null
if [ $? -ne 0 ]; then
    echo "Upgrading failed."
else
    echo "Updating succeeded."
fi

echo "Stargin qBittorrent and PIA..."
./run_setup.sh
