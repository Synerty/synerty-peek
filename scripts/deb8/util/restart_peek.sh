#!/bin/bash

for s in peek_agent peek_worker peek_client peek_server
do
        echo "Stopping $s"
        sudo service $s stop
done

echo "Waiting for services to stop"
sleep 5s

echo "Killing anything left running"
pkill -9 -u $USER -f python || true

echo "Deleting logs"
rm ~peek/peek_*.log


for s in peek_server peek_agent peek_worker peek_client
do
        echo "Starting $s"
        sudo service $s start
done

