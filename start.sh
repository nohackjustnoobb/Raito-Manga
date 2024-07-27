#!/bin/bash

echo "Runing setup script"
python3 setup.py

echo "Starting Raito-Sync"
cd /app/sync && ./Raito-Sync &

echo "Starting Raito-Server"
cd /app/api/build && stdbuf -oL ./Raito-Server &

echo "Starting Nginx"
nginx -g 'daemon off;'
