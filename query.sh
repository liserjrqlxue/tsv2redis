#!/bin/bash
echo query query.snp.list
cat query.snp.list |perl query.redis.pl SEQ2000_all_native_snp > query.snp.result
echo query query.indel.list
cat query.indel.list |perl query.redis.pl SEQ2000_all_native_indel > query.indel.result
