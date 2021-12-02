#!/bin/bash
source $HOME/.bash_profile
dnsServerIPs="10.0.10.4 10.0.10.5"
subscription="xxx"
resourceGroup="xxx"
runSendMailScript="dns-send-mail.sh"

az account set -s $subscription

for dnsServerIP in $dnsServerIPs
do

  logFile="$HOME/dns/_check-dns_${dnsServerIP}.log"
  #echo "DNS Server IP: "${dnsServerIP} >> $logFile
  [[ -f $logFile ]] && rm $logFile
  function checkDNS() {
    az network private-dns zone list --query "[].name" -o tsv | while read domainName
    do
      if [[ $domainName != *"privatelink"* ]];then continue; fi
      echo $domainName
      # echo $domainName >> $logFile
      az network private-dns record-set a list -g $resourceGroup -z $domainName --query "[].fqdn" -o tsv | while read fqdn
      do
        ip=`nslookup $fqdn $dnsServerIP | grep Address | tail -1 | awk 'BEGIN {FS=" "} {print $2}'`
        if [[ $ip != *"10."* ]];then
          echo "     " $fqdn: $ip
          echo "     " $fqdn: $ip"\n" >> $logFile
        fi
      done
    done
  }

  function isSendMail() {
    cat $logFile | grep -v "10." | wc -l
  }

  checkDNS
  sendMail=$(isSendMail)
  if [[ $sendMail > 0 ]];then
    $HOME/dns/$runSendMailScript $dnsServerIP
  fi

done