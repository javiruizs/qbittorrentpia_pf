#!/bin/bash

cd /root/scripts

apt update

apt --only-upgrade install qbittorrent qbittorrent-nox -y

./run_setup.sh