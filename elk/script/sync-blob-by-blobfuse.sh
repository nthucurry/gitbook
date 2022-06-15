#!/bin/bash
source $HOME/.bash_profile

HH=$1
[ ! -z $1 ] && HH=$1 || HH=9

getYY=`date +%Y --date="-$HH Hour"`
getMM=`date +%m --date="-$HH Hour"`
getDD=`date +%d --date="-$HH Hour"`
getHH=`date +%H --date="-$HH Hour"` # LST -> UTC
delYY=`date +%Y --date="-$((HH+112)) Hour"`
delMM=`date +%m --date="-$((HH+112)) Hour"`
delDD=`date +%d --date="-$((HH+112)) Hour"`
delHH=`date +%H --date="-$((HH+112)) Hour"` # LST -> UTC
blobList="$HOME/sync-blob-list.txt"

# echo "______ $getYY/$getMM/$getDD ______"

cat $blobList | while read srcPath
do
  if [[ $srcPath == *"#"* ]];then
    continue;
  fi
  dstPath=`echo $srcPath | sed 's/data-from-cloud/data-to-local/g'`

  rm -fr $dstPath/y=$getYY/m=$getMM/d=$getDD

  mkdir -p $dstPath/y=$getYY/m=$getMM/d=$getDD
  # echo "  1.  mkdir -p $dstPath/y=$getYY/m=$getMM/d=$getDD"

  cp -fr $srcPath/y=$getYY/m=$getMM/d=$getDD/h=$getHH $dstPath/y=$getYY/m=$getMM/d=$getDD
  # echo "  2.  cp -fr $srcPath/y=$getYY/m=$getMM/d=$getDD/h=$getHH $dstPath/y=$getYY/m=$getMM/d=$getDD"

  if [[ $srcPath == *"NETWORKSECURITYGROUP"* ]];then
    # echo "      ~/update-file-for-nsg.sh $dstPath/y=$getYY/m=$getMM/d=$getDD/h=$getHH"
    $HOME/update-file-for-nsg.sh $dstPath/y=$getYY/m=$getMM/d=$getDD/h=$getHH > /dev/null
  fi

  rm -fr $dstPath/y=$delYY/m=$delMM/d=$delDD/h=$delHH
done