#!/bin/bash
set -e

echo "starting deployment"

export PATH=$PATH
export GOPATH=/home/ec2-user/go

if ! command -v &> /dev/null; then
    echo "Go command not found after setting PATH"
    echo "Path is: $PATH"
fi

echo "Go version: $(go version)"

cd /var/www/myapp

if [! -f "go.mod"]; then
    echo "go.mod not found"
    exit 1
fi

echo "downloading go dependencies"
go mod download

echo "building go deps"
go build -o myapp .

chmod +x myapp

chown ec2-user:ec2-user my-app

echo "Build completed successfully"

pkill -f myapp || true
sleep 2

echo "starting application"
nohup ./myapp > /var/log/myapp.log 2>&1 &

sleep 3

if pgrep -f myapp > /dev/null; then
    echo "Application started!"
    echo "PID: $(pgrep -f myapp)"
else
    echo "failed to start"
    tail -20 /var/log/myapp.log
    exit 1
fi