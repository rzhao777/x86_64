#!/bin/sh

SUB_URL="你的订阅地址"

curl -s $SUB_URL -o /tmp/sub.json

# 假设已转换为 sing-box 格式
cp /tmp/sub.json /etc/sing-box/config.json

/etc/init.d/singbox restart
