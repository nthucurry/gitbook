#!/bin/bash

/usr/bin/expect << EOF
spawn telnet mail-relay.example.com 25
send "EHLO auo.com"
send "MAIL FROM: <alert@example.com>"
send "RCPT TO: <user@example.com>"
send "DATA"
send "Subject: test"
send "Hello,"
send "This is an email sent by using the telnet command."
send "."
send "quit"
interact
eof