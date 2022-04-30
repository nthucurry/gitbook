#!/bin/bash
targetIP=$1
cat /data-from-cloud/eda-azure-squid/proxy-*/access.log | grep $targetIP | awk '{print $3,$7}' | sort > tmp.txt
uniq tmp.txt -c > tmp1.txt
sort -rn tmp1.txt
rm tmp*.txt