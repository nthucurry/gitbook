#!/bin/bash

podNames=`oc get pod -n zen | grep $1 | awk 'BEGIN {FS=" "} {print $1}'`
for podName in $podNames
do
  echo $podName
  oc logs $podName > ~/2022-0107/$podName.log
done