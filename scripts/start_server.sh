#!/bin/bash
echo "starting deployment"

export PATH=$PATH:/usr/local/go/bin:/usr/bin:/bin
export GOPATH=/home/ec2-user/go

if [ -f "/usr/local/bin/go" ]; then
    echo "go binary found"
    GO_CMD="usr/local/bin/go"
elif command -v go &> /dev/null; then
    echo "go found in path"
    GO_CMD="go"
else
    echo "go isn't installed"
    ls -la /usr/local/go/bin || echo "go dir doesn't exist"
    echo "current path: $PATH"
    exit 1
fi

echo "go version: $($GO_CMD version)"

cd /var/www/myapp

echo "current dir: $(pwd)"
echo "folder contents"
ls -la

if [ ! -f "go.mod" ]; then
    echo "go.mod not found"
    exit 1
fi

echo "downloading deps"
$GO_CMD mod download

echo "building app"
$GO_CMD build -o myapp .

chmod +x myapp
chown ec2-user:ec2-user myapp

echo "build completed"

echo "stopping old instance"
pkill -f myapp || true
sleep 2

echo "starting app"
nohup ./myapp > /var/log/myapp.log 2>&1 &

sleep 3

if pgrep -f myapp > /dev/null; then
    echo "app started!"
    echo "PID: $(pgrep -f myapp)"
else
    echo "failed to start"
    tail -20 /var/log/myapp.log 2>&1 || echo "no log found"
    exit 1
fi