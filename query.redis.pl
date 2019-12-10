#!/bin/env perl
#
use strict;
use warnings;

use Redis::Client;
use JSON;

$#ARGV<0 and die"$0 hashName\n";
# redis server
#my$host="192.168.136.114";
my$host="127.0.0.1";
my$port=6379;
#print STDERR scalar localtime(),"\tstart redis client\n";
my$client=Redis::Client->new(host=>$host,port=>$port);

#my$hashName="native_snp";
my$hashName=shift;
#print STDERR scalar localtime(),"\tstart input query key:\n";
while(<>){
	chomp;
	$_ or last;
	my$key=$_;
	my$value=$client->hget($hashName,$key);
	my$item=from_json($value);
	print join("\t",@$item),"\n";
}
