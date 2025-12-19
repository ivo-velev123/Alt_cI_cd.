#!/bin/bash
set -e

echo "Starting installation"

yum update -y

if [ -f "usr/local/go/bin/go" ]; then
    echo "Go is already installed"
else
    echo "Installing Go"

    cd /tmp

    rm -f go1.21.5.linux-amd64.tar.gz

    wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz

    rm -rf /usr/local/go

    tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz

    if [ -f "usr/local/go/bin/go"]; then
        echo "go installed successfully"
    else
        echo "go install failed"
        exit 1
    fi

    rm -f go1.21.5.linux-amd64.tar.gz

    echo "Go installed"
fi

echo "setting up app dir"

mkdir -p /var/www/myapp
chown -R ec2-user:ec2-user /var/www/myapp

echo "Completed"