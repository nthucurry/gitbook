dnsServerIP="10.86.15.1"

az network private-dns zone list --query "[].name" -o tsv | while read domainName
do
    echo $domainName
    az network private-dns record-set a list -g Global -z $domainName \
		--query "[].fqdn" -o tsv | while read fqdn
    do
#    ip=`nslookup $fqdn $dnsServerIP | grep Address | tail -1 | awk 'BEGIN {FS=" "} {print $2}'`
    ip=`nslookup $fqdn $dnsServerIP | grep ":" | tail -1`
    if [[ $ip != *"10."* ]];then
		echo "     " $fqdn: $ip
    fi
  done
done