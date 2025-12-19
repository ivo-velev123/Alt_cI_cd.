#!/bin/bash

yum update -y

cd /tmp

wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz

if ! grep -q "/usr/local/go/bin" /etc/profile; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >> etc/profile
fi

export PATH=$PATH:usr/local/go/bin

go version