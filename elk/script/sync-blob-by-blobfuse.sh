#!/bin/bash
source $HOME/.bash_profile

getYY=`date +%Y`
getMM=`date +%m`
getDD=`date +%d`
getHH=`date +%H --date="-9 Hour"` # LST -> UTC
delYY=`date +%Y --date="-22 Hour"`
delMM=`date +%m --date="-22 Hour"`
delDD=`date +%d --date="-22 Hour"`
delHH=`date +%H --date="-22 Hour"` # LST -> UTC
blobList="$HOME/sync-blob-list.txt"

# echo "______ $getYY/$getMM/$getDD ______" >> $HOME/_sync-blob_$getYY-$getMM$getDD.log

cat $blobList | while read srcPath
do
  if [[ $srcPath == *"#"* ]];then
    continue;
  fi
  dstPath=`echo $srcPath | sed 's/data-from-cloud/data-to-local/g'`
  mkdir -p $dstPath/y=$getYY/m=$getMM/d=$getDD
  # echo "  mkdir -p $dstPath/y=$getYY/m=$getMM/d=$getDD"
  cp -fr $srcPath/y=$getYY/m=$getMM/d=$getDD/h=$getHH $dstPath/y=$getYY/m=$getMM/d=$getDD
  # echo "    cp -fr $srcPath/y=$getYY/m=$getMM/d=$getDD/h=$getHH $dstPath/y=$getYY/m=$getMM/d=$getDD"
  if [[ $srcPath == *"NETWORKSECURITYGROUP"* ]];then
    # echo "      ~/update-file-for-nsg.sh $dstPath/y=$getYY/m=$getMM/d=$getDD/h=$getHH"
    $HOME/update-file-for-nsg.sh $dstPath/y=$getYY/m=$getMM/d=$getDD/h=$getHH
  fi
  rm -fr $dstPath/y=$delYY/m=$delMM/d=$delDD/h=$delHH
done