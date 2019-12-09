#!/bin/env perl
#
use strict;
use warnings;

use Redis::Client;
use JSON;

$#ARGV<1 and die"$0 hashName tsv keyIndex\n";
# redis server
#my$host="192.168.136.114";
my$host="127.0.0.1";
my$port=6379;
my$client=Redis::Client->new(host=>$host,port=>$port);

#my$hashName="native_snp";
my$hashName=shift;
my$tsv=shift;
my$keyIndex=shift;
defined$keyIndex or $keyIndex=0;
my@keyIndex=split /,/,$keyIndex;


open IN,"zcat -f $tsv|" or die$!;
my%hash;
my$count=0;
while(<IN>){
	chomp;
	my@ln=split /\t/,$_;
	my$key=join("_",@ln[@keyIndex]);
	$hash{$key}=to_json(\@ln);
	$count++;
	if($count>=524287){
		$client->hmset($hashName,%hash) or die$!;
		print STDERR "update $count record\n";
		$count=0;
		%hash=();
	}
#	$client->hset($hashName,$key=>$hash{$key});
}
close IN;
$count
	and $client->hmset($hashName,%hash) or die$!;
print STDERR "update $count record\n";
