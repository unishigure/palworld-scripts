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

echo $(date) : 30 mins before shutdown.
curl --basic -u admin:$PASS \
    -X POST "http://localhost:$PORT/v1/api/announce" \
    -H 'Content-Type: application/json' \
    --data-raw '{
        "message": "('"$(date "+%T")"') The server will restart after 30 minutes."
    }'
echo
sleep 1200

echo $(date) : 10 mins before shutdown.
curl --basic -u admin:$PASS \
    -X POST "http://localhost:$PORT/v1/api/announce" \
    -H 'Content-Type: application/json' \
    --data-raw '{
        "message": "('"$(date "+%T")"') The server will restart after 10 minutes."
    }'
echo
sleep 300

echo $(date) : 5 mins before shutdown.
curl --basic -u admin:$PASS \
    -X POST "http://localhost:$PORT/v1/api/announce" \
    -H 'Content-Type: application/json' \
    --data-raw '{
        "message": "('"$(date "+%T")"') The server will restart after 5 minutes."
    }'
echo
sleep 120

echo $(date) : 3 mins before shutdown.
curl --basic -u admin:$PASS \
    -X POST "http://localhost:$PORT/v1/api/announce" \
-H 'Content-Type: application/json' \
    --data-raw '{
        "message": "('"$(date "+%T")"') The server will restart after 3 minutes."
    }'
echo
sleep 120

echo $(date) : 1 min before shutdown. Set shutdown.
curl --basic -u admin:$PASS \
    -X POST "http://localhost:$PORT/v1/api/shutdown" \
    -H 'Content-Type: application/json' \
    --data-raw '{
        "waittime": 60,
        "message": "('"$(date "+%T")"') Server will shutdown in 60 seconds."
    }'
echo $(date) : Server saving.
curl --basic -u admin:$PASS \
    -X POST "http://localhost:$PORT/v1/api/save" \
    -H 'Content-Length: 0'
echo
sleep 60

echo $(date) : Server shutdown.
exit 0
