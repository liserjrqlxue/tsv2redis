#!/bin/bash
perl tsv2redis.pl SEQ2000_all_native_indel all_native_indel20191206.gff 0,1,2,3
perl tsv2redis.pl SEQ2000_all_native_snp all_native_snp20191206.gff 0
