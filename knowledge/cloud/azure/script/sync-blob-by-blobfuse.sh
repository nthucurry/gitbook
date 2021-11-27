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
blobList="$HOME/sync-blob-list.txt"

# echo "______ $getYY/$getMM/$getDD ______" >> $HOME/_sync-blob_$getYY-$getMM$getDD.log

cat $blobList | while read line
do
  if [[ $line == *"#"* ]];then
    continue;
  fi
  blobPath=`echo $line | sed 's/data-from-blobfuse/data-to-local/g'`
  mkdir -p $blobPath/y=$getYY/m=$getMM/d=$getDD
  cp -r $line/y=$getYY/m=$getMM/d=$getDD/h=$getHH $blobPath/y=$getYY/m=$getMM/d=$getDD
  rm -fr $blobPath/y=$delYY/m=$delMM/d=$delDD/h=$delHH
done