#!/bin/sh

if [ ! -f "/config/channels.json" ]; then
    cp ./channels.example.json /config/channels.json
fi

if [ ! -f "/config/config.json" ]; then
    cp ./config.example.json /config/config.json
fi

chown -R $PUID:$PGID /config
chown -R $PUID:$PGID /config/*

go run cmd/main.go