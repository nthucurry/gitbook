#!/bin/bash
#1650765033.170 488858 10.248.12.50 TCP_TUNNEL/200 14165 CONNECT management.azure.com:443 - HIER_DIRECT/40.78.234.177 -

targetIPs=$1
if [[ -z $targetIPs ]];then
  cat /data-from-cloud/eda-azure-squid/proxy-*/access.log | awk '{print $7}' | sort > tmp1.txt
else
  cat /data-from-cloud/eda-azure-squid/proxy-*/access.log | grep -E $targetIPs | awk '{print $7}' | sort > tmp1.txt
fi
uniq tmp1.txt -c > tmp2.txt
sort -rn tmp2.txt
rm tmp*.txt