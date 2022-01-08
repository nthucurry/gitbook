#!/bin/bash

for ip in 192.168.201.{1..254};
do
  sudo arp -d $ip > /dev/null 2>&1
  ping -c 5 $ip > /dev/null 2>&1 &
done
wait
arp -na | grep -v "incomplete"

nmap -sP 192.168.1.0/24