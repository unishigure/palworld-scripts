#!/bin/bash -l

if [ -n "$PAL_ADMIN_PASS" ]; then
    PASS=$PAL_ADMIN_PASS
else
    echo 'Please set the "$PAL_ADMIN_PASS" environment variable.'
    exit -1
fi

if [ -n "$PAL_API_PORT" ]; then
    PORT=$PAL_API_PORT
else
    PORT=8212
fi

echo $(date) : Restart 30 mins ago
curl --basic -u admin:$PASS \
    -X POST "http://localhost:$PORT/v1/api/announce" \
    -H 'Content-Type: application/json' \
    --data-raw '{
        "message": "('"$(date "+%T")"') The server will restart after 30 minutes."
    }'
sleep 1200

echo $(date) : Restart 10 mins ago
curl --basic -u admin:$PASS \
    -X POST "http://localhost:$PORT/v1/api/announce" \
    -H 'Content-Type: application/json' \
    --data-raw '{
        "message": "('"$(date "+%T")"') The server will restart after 10 minutes."
    }'
sleep 300

echo $(date) : Restart 5 mins ago
curl --basic -u admin:$PASS \
    -X POST "http://localhost:$PORT/v1/api/announce" \
    -H 'Content-Type: application/json' \
    --data-raw '{
        "message": "('"$(date "+%T")"') The server will restart after 5 minutes."
    }'
sleep 120

echo $(date) : Restart 3 mins ago
curl --basic -u admin:$PASS \
    -X POST "http://localhost:$PORT/v1/api/announce" \
-H 'Content-Type: application/json' \
    --data-raw '{
        "message": "('"$(date "+%T")"') The server will restart after 3 minutes."
    }'
sleep 120

echo $(date) : Restart 1 min ago
curl --basic -u admin:$PASS \
    -X POST "http://localhost:$PORT/v1/api/shutdown" \
    -H 'Content-Type: application/json' \
    --data-raw '{
        "waittime": 60,
        "message": "('"$(date "+%T")"') Server will shutdown in 10 seconds."
    }'
curl --basic -u admin:$PASS \
    -X POST "http://localhost:$PORT/v1/api/save" \
    -H 'Content-Length: 0'
sleep 60

echo $(date) : Server restarting
exit 0
