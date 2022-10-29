#!/bin/bash

status=`systemctl status elasticsearch.service | grep 'Active: failed'`
echo `date` $status >> /tmp/monitor_elasticsearch.log
[[ -z "$status" ]] || systemctl restart elasticsearch.service