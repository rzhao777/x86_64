#!/bin/sh

NODES="node1 node2 node3"
BEST=""
BEST_SCORE=9999

for NODE in $NODES
do
LAT=$(ping -c 2 $NODE | grep avg | awk -F '/' '{print $5}')
LOSS=$(ping -c 3 $NODE | grep -o '[0-9]*% packet loss' | cut -d% -f1)

```
[ -z "$LAT" ] && LAT=9999
[ -z "$LOSS" ] && LOSS=100

SCORE=$(expr $LAT + $LOSS \* 10)

if [ "$SCORE" -lt "$BEST_SCORE" ]; then
    BEST_SCORE=$SCORE
    BEST=$NODE
fi
```

done

uci set sing-box.config.outbound=$BEST
uci commit sing-box

/etc/init.d/singbox restart
