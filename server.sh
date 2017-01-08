#!/bin/bash   
# monitor the systam and return results as json over http
# created on ubuntu
# author: enile8

# set default variables
PORT=8080

# parse various arguments to set the server up
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -p|--port)
    PORT="$2"
    shift
    ;;
    *)
    # oh snap, unknown option
    ;;
esac
shift
done

# collect the data we want to return
data() {
    CPU="`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`"
    SWAP="`free -h | grep "Swap" | awk {'print $3'}`"
    RAM="`free -h | grep "Mem" | awk {'print $3'}`"
    HDD="`df -lh | awk '{if ($6 == "/") { print $5 }}' | head -1 | cut -d'%' -f1`"
    echo "{\"cpu\":\"${CPU}\", \"swap\":\"${SWAP}\", \"ram\":\"${RAM}\", \"hdd\":\"${HDD}\"}"
}

# serve it...
while true;
    do {
        echo -e 'HTTP/1.1 200 OK\nContent-Type:application/json;charset=utf-8\nServer:enile8 monitor\n'; echo `data`; } | nc -l $PORT; 
    done