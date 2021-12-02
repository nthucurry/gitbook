#!/bin/bash
source $HOME/.bash_profile

mailRelay="mail-relay.corpnet.axo.com"
dnsServerIP=$1
expFile="$HOME/dns/mail-for-check-dns.exp"
dnsLogFile="$HOME/dns/_check-dns_${dnsServerIP}.log"
dnsLog=`cat $dnsLogFile`

cat << EOF | tee $expFile
#!/usr/bin/expect -f
spawn /usr/bin/telnet ${mailRelay} 25
expect "220 ${mailRelay} ESMTP Postfix"
send "EHLO axo.com\r"
expect "250 DNS"
send "MAIL FROM: alert@axo.com\r"
expect "250 2.1.0 Ok"
send "RCPT TO: test@axo.com\r"
send "RCPT TO: pm@axo.com\r"
expect "250 2.1.5 Ok"
send "DATA\r"
expect "354 End data with <CR><LF>.<CR><LF>"
send "Subject: Azure Private DNS Status (${dnsServerIP}) \r"
send "========== Private DNS Zone ==========\r"
send "\t${dnsLog}\r"
send ".\r"
expect "250 2.0.0 Ok: queued as E73FDE07B6"
send "quit\r"
EOF

chmod +x $expFile
$expFile