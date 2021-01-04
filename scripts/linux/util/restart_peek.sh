#!/bin/bash

for s in peek_agent peek_worker peek_office peek_field peek_logic; do
    echo "Stopping $s"
    sudo systemctl stop ${s}.service
done

echo "Waiting for services to stop"
sleep 5s

echo "Killing anything left running"
pkill -9 -u $USER -f python || true

for s in peek_agent peek_worker peek_office peek_field peek_logic; do
    echo "Starting $s"
    sudo systemctl restart ${s}.service
done
