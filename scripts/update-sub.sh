#!/bin/sh

URL="你的订阅地址"

curl -s $URL -o /tmp/sub.json
cp /tmp/sub.json /etc/sing-box/config.json

/etc/init.d/singbox restart
