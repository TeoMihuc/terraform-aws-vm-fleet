#!/bin/bash
LST_IP=("$(cat /tmp/list-private-ip.txt)")
COUNT=0

ARRAY=()
for i in $LST_IP; do
    ARRAY+=("$i")
done

for ITEM in ${ARRAY[@]}; do
    LIST_LENGTH=${#ARRAY[@]}
    LAST_LOOP=$LIST_LENGTH-1
    if [[ $COUNT -ge $LAST_LOOP ]]; then
    echo "ssh onto ${ARRAY[$COUNT]}"
    echo "ping from ${ARRAY[$COUNT]} ${ARRAY[0]}"
    ssh -oStrictHostKeyChecking=no -i /tmp/myKey-$COUNT.pem $1@${ARRAY[$COUNT]} "ping -c 2 ${ARRAY[0]}"
    echo "End of roundrobbin" && exit 0
    else
    echo "ssh onto ${ARRAY[$COUNT]}"
    echo "ping from ${ARRAY[$COUNT]} ${ARRAY[$((COUNT+1))]}"
    ssh -oStrictHostKeyChecking=no -i /tmp/myKey-$COUNT.pem $1@${ARRAY[$COUNT]} "ping -c 2 ${ARRAY[$((COUNT+1))]}"
    COUNT=$((COUNT+1))
    fi
done