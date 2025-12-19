#!/bin/bash
echo "stopping application"

pkill -f myapp || true

sleep 2

if pgrep -f myapp > /dev/null; then
    pkill -9 -f myapp || true
    sleep 1
fi

echo "application stopped"