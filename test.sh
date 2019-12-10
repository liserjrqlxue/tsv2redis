#!/bin/bash
echo test redis master server
cat test.redids.cli|./redis/src/redis-cli
echo test redis slave  server
cat test.redids.cli|./redis/src/redis-cli -p 6380
