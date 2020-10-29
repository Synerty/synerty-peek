#!/bin/bash

for s in peek_agent_service peek_worker_service peek_office_service peek_logic_service
do
        echo "Stopping $s"
        sudo systemctl stop ${s}.service
done

echo "Waiting for services to stop"
sleep 5s

echo "Killing anything left running"
pkill -9 -u $USER -f python || true

for s in peek_logic_service peek_agent_service peek_worker_service peek_office_service
do
        echo "Starting $s"
        sudo systemctl restart ${s}.service
done

