#/bin/bash
source $HOME/.bash_profile

dstPath=$1
find $dstPath -iname "*.json" | while read line
do
  echo `echo "" >> $line`
done