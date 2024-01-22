#!/bin/bash -l

ANSI_FILTER="s/\x1b\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[mGK]//g"

echo $(date) : Restart 30 mins ago
ARRCON -H localhost -P $PAL_RCON_PORT -p $PAL_ADMIN_PASS "broadcast The_server_will_restart_after_30_minutes" | sed -E $ANSI_FILTER
sleep 1200

echo $(date) : Restart 10 mins ago
ARRCON -H localhost -P $PAL_RCON_PORT -p $PAL_ADMIN_PASS "broadcast The_server_will_restart_after_10_minutes" | sed -E $ANSI_FILTER
sleep 300

echo $(date) : Restart 5 mins ago
ARRCON -H localhost -P $PAL_RCON_PORT -p $PAL_ADMIN_PASS "broadcast The_server_will_restart_after_5_minutes" | sed -E $ANSI_FILTER
sleep 120

echo $(date) : Restart 3 mins ago
ARRCON -H localhost -P $PAL_RCON_PORT -p $PAL_ADMIN_PASS "broadcast The_server_will_restart_after_3_minutes" | sed -E $ANSI_FILTER
sleep 120

echo $(date) : Restart 1 min ago
ARRCON -H localhost -P $PAL_RCON_PORT -p $PAL_ADMIN_PASS "shutdown 60" | sed -E $ANSI_FILTER
sleep 60

echo $(date) : Server restarting
exit 0
