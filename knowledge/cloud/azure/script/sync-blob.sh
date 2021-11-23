#!/bin/bash

source $HOME/.bash_profile

getYY=`date +%Y`
getMM=`date +%m`
getDD=`date +%d`
getHH=`date +%H --date="-9 Hour"` # LST -> UTC
delYY=`date +%Y --date="-12 Hour"`
delMM=`date +%m --date="-12 Hour"`
delDD=`date +%d --date="-12 Hour"`
delHH=`date +%H --date="-12 Hour"` # LST -> UTC


echo "______ $getYY/$getMM/$getDD ______" >> $HOME/_sync-blob_$getYY-$getMM$getDD.log

cat $HOME/log-path.txt | while read line
do
  if [[ $line == *"#"* ]];then
    continue;
  fi
  blobPath=`echo $line | sed 's/data-for-blobfuse/data-for-filebeat/g'`
  mkdir -p $blobPath/y=$getYY/m=$getMM/d=$getDD
  # echo "mkdir -p $blobPath/y=$getYY/m=$getMM/d=$getDD" >> $HOME/_sync-blob_$getYY-$getMM$getDD.log

  cp -r $line/y=$getYY/m=$getMM/d=$getDD/h=$getHH $blobPath/y=$getYY/m=$getMM/d=$getDD
  # echo "cp -r $line/y=$getYY/m=$getMM/d=$getDD $blobPath/y=$getYY/m=$getMM/d=$getDD/h=$getHH" >> $HOME/_sync-blob_$getYY-$getMM$getDD.log

  rm -fr $blobPath/y=$delYY/m=$delMM/d=$delDD/h=$delHH
  # echo "rm -fr $blobPath/y=$delYY/m=$delMM/d=$delDD/h=$delHH" >> $HOME/_sync-blob_$getYY-$getMM$getDD.log
  # rmdir $blobPath/y=$getYY/m=$getMM/d=$getDD
done