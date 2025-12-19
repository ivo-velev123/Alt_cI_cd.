#!/bin/bash
export PATH=$PATH:usr/local/go/bin

cd /var/www/myapp

go mod download

go build -o myapp .

chmod +x myapp

nohup ./myapp > var/log/myapp.log 2>&1 &

sleep 2

if pgrep -f myapp > /dev/null; then
    echo "Application running successfully"
else
    echo "Application failed to start"
    exit 1
fi