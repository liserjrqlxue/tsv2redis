#!/bin/bash
echo shutdown redis master server
echo SHUTDOWN | ./redis/src/redis-cli
echo shutdown redis slave  server
echo SHUTDOWN | ./redis/src/redis-cli -p 6380
